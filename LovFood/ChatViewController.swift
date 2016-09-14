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

    fileprivate var localTyping = false
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
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        messageRef = dataBaseRef.child("messages")

    }


    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!,
                                     senderDisplayName: String!, date: Date!) {

        
        //CONVERT FROM NSDate to String
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
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
    override func didPressAccessoryButton(_ sender: UIButton) {
        self.inputToolbar.contentView!.textView!.resignFirstResponder()
        
        let sheet = UIAlertController(title: "Media messages", message: nil, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Send photo", style: .default) { (action) in

        }
        
        let locationAction = UIAlertAction(title: "Send location", style: .default) { (action) in

        }
        
        let videoAction = UIAlertAction(title: "Send video", style: .default) { (action) in
 
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(photoAction)
        sheet.addAction(locationAction)
        sheet.addAction(videoAction)
        sheet.addAction(cancelAction)
        
        self.present(sheet, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        finishReceivingMessage()
        observeMessages()
        observeTyping()
        
    }

    
    
    func addMessage(_ id: String, date: Date, text: String) {
        let message = JSQMessage(senderId: id, senderDisplayName: self.senderDisplayName, date: date, text: text)
        messages.append(message!)
    }
    func addMedia(_ media:JSQMediaItem) {
        let message = JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: media)
        self.messages.append(message!)
        self.finishSendingMessage(animated: true)
    }
 
    

    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!,
                                 avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return nil
        } else {
            return incomingAvatarImageView
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
            as! JSQMessagesCollectionViewCell
        
        let message = messages[(indexPath as NSIndexPath).item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.white
        } else {
            cell.textView!.textColor = UIColor.black
        }
        
        return cell
    }
    
    fileprivate func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(with: lovFoodColor)
        incomingBubbleImageView = factory?.incomingMessagesBubbleImage(
            with: UIColor.jsq_messageBubbleLightGray())
    }
    fileprivate func setupAvatarImages() {
         incomingAvatarImageView = JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "lisa_small"), diameter: 30)

    }
    
    fileprivate func observeMessages() {
        let messagesQuery = messageRef.queryLimited(toLast: 25)
    
        messagesQuery.observe(.childAdded) { (snapshot: FIRDataSnapshot!) in

            let id = (snapshot.value as! NSDictionary)["senderId"] as! String
            let text = (snapshot.value as! NSDictionary)["text"] as! String
            let dateString = (snapshot.value as! NSDictionary)["date"] as! String
            
            //CONVERT String to NSDate
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "yyyy-MM-dd"
             let date = dateFormatter.date(from: dateString)!
            self.addMessage(id, date: date, text: text)
            
            self.finishReceivingMessage()
        }
    }
    
    fileprivate func observeTyping() {
        let typingIndicatorRef = dataBaseRef.child("typingIndicator")
        userIsTypingRef = typingIndicatorRef.child(senderId)
        userIsTypingRef.onDisconnectRemoveValue()
        usersTypingQuery = typingIndicatorRef.queryOrderedByValue().queryEqual(toValue: true)
        usersTypingQuery.observe(.value) { (data: FIRDataSnapshot!) in
            
            // 3 You're the only typing, don't show the indicator
            if data.childrenCount == 1 && self.isTyping {
                return
            }
            
            // 4 Are there others typing?
            self.showTypingIndicator = data.childrenCount > 0
            self.scrollToBottom(animated: true)
        }
        
    }
    override func textViewDidChange(_ textView: UITextView) {
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
