//
//  ChatViewController.swift
//  LovFood
//
//  Created by Nikolai Kratz on 09.07.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase

class ChatViewController: JSQMessagesViewController {
    
    // MARK: Properties
    var messages = [JSQMessage]()
    var messageRef: FIRDatabaseReference!
    
    var userIsTypingRef: FIRDatabaseReference!
    var usersTypingQuery: FIRDatabaseQuery!
    
    let imagePicker = UIImagePickerController()

    private var localTyping = false
    var isTyping: Bool {
        get {
            return localTyping
        }
        set {
            // 3
            localTyping = newValue
            userIsTypingRef.setValue(newValue)
        }
    }
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    var incomingAvatarImageView: JSQMessagesAvatarImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lisa"
        
        setupBubbles()
        setupAvatarImages()
       // collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        messageRef = dataBaseRef.child("messages")

    }


    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
                                     senderDisplayName: String!, date: NSDate!) {

        
        //CONVERT FROM NSDate to String
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.stringFromDate(date)
        //SAVE MESSAGE IN DATABASE
        let itemRef = messageRef.childByAutoId()
        let messageItem = [ // 2
            "text": text,
            "senderId": senderId,
            "date": dateString
        ]
        itemRef.setValue(messageItem)
 
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
    
        finishSendingMessage()
        isTyping = false
    }
    override func didPressAccessoryButton(sender: UIButton) {
        self.inputToolbar.contentView!.textView!.resignFirstResponder()
        
        let sheet = UIAlertController(title: "Media messages", message: nil, preferredStyle: .ActionSheet)
        
        let photoAction = UIAlertAction(title: "Send photo", style: .Default) { (action) in

        }
        
        let locationAction = UIAlertAction(title: "Send location", style: .Default) { (action) in

        }
        
        let videoAction = UIAlertAction(title: "Send video", style: .Default) { (action) in
 
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        sheet.addAction(photoAction)
        sheet.addAction(locationAction)
        sheet.addAction(videoAction)
        sheet.addAction(cancelAction)
        
        self.presentViewController(sheet, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        finishReceivingMessage()
        observeMessages()
        observeTyping()
        
    }

    
    
    func addMessage(id: String, date: NSDate, text: String) {
        let message = JSQMessage(senderId: id, senderDisplayName: self.senderDisplayName, date: date, text: text)
        messages.append(message)
    }
    func addMedia(media:JSQMediaItem) {
        let message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: media)
        self.messages.append(message)
        self.finishSendingMessageAnimated(true)
    }
 
    

    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return nil
        } else {
            return incomingAvatarImageView
        }
    }

    override func collectionView(collectionView: UICollectionView,
                                 cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
            as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor.blackColor()
        }
        
        return cell
    }
    
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(lovFoodColor)
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleLightGrayColor())
    }
    private func setupAvatarImages() {
         incomingAvatarImageView = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "lisa_small"), diameter: 30)

    }
    
    private func observeMessages() {
        let messagesQuery = messageRef.queryLimitedToLast(25)
    
        messagesQuery.observeEventType(.ChildAdded) { (snapshot: FIRDataSnapshot!) in

            let id = snapshot.value!["senderId"] as! String
            let text = snapshot.value!["text"] as! String
            let dateString = snapshot.value!["date"] as! String
            
            //CONVERT String to NSDate
             let dateFormatter = NSDateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd"
             let date = dateFormatter.dateFromString(dateString)!
            self.addMessage(id, date: date, text: text)
            
            self.finishReceivingMessage()
        }
    }
    
    private func observeTyping() {
        let typingIndicatorRef = dataBaseRef.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqualToValue(true)
        usersTypingQuery.observeEventType(.Value) { (data: FIRDataSnapshot!) in
            
            // 3 You're the only typing, don't show the indicator
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
            // 4 Are there others typing?
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottomAnimated(true)
        }
        
    }
    override func textViewDidChange(textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        print(textView.text != "")
        isTyping = textView.text != ""
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
