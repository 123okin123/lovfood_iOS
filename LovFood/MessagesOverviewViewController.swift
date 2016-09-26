//
//  MessagesOverviewViewController.swift
//  LovFood
//
//  Created by Nikolai Kratz on 16.06.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import Firebase

class MessagesOverviewViewController: UITableViewController {

    @IBOutlet weak var unreadIndicator: UIView!

    
    var conversations = [Conversation]()
    var unreadConversationsCount = 0
    var query  :FIRDatabaseQuery!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func checkForUnreadConversations() {
        unreadConversationsCount = 0
        for conversation in conversations {
            if let unreadIds = conversation.unreadIds {
                for id in unreadIds {
                    if id == user.uid {
                        unreadConversationsCount += 1
                    }
                }
            }
        }
        if unreadConversationsCount == 0 {
        navigationController?.tabBarItem.badgeValue = nil
        } else {
        navigationController?.tabBarItem.badgeValue = String(unreadConversationsCount)
        }
    }
    
    func addConversationsDBObserver() {
        
        query = dataBaseRef.child("conversations").queryOrdered(byChild: "users/\(user.uid)").queryEqual(toValue: true)
        query.observe(.childAdded, with: { (snapshot) in
            let conversation = Conversation(snapshot: snapshot)
            conversation.users = [CookingProfile?](repeating: nil, count: conversation.userIds!.count)
            if let userIds = conversation.userIds {
                for i in 0...userIds.count - 1 {
                    usersDBRef.child(conversation.userIds![i]).observeSingleEvent(of: .value, with: { (snapshot) in
                        let profile = CookingProfile(snapshot: snapshot)
                        conversation.users![i] = profile
                        if !conversation.users!.contains(where: {(profile) in return profile == nil}) {
                            self.conversations.append(conversation)
                            self.checkForUnreadConversations()
                            self.tableView.reloadData()
                        }
                    })
                    
                }
            }
            
        })
        query.observe(.childRemoved, with: { (snapshot) in
            let conversation = Conversation(snapshot: snapshot)
            if let index = self.conversations.index(where: {$0.id == conversation.id}) {
            self.conversations.remove(at: index)
            self.tableView.deleteRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
            }
        })
        query.observe(.childChanged, with: { (snapshot) in
            let conversation = Conversation(snapshot: snapshot)
            conversation.users = [CookingProfile?](repeating: nil, count: conversation.userIds!.count)
            if let userIds = conversation.userIds {
                for i in 0...userIds.count - 1 {
                    usersDBRef.child(conversation.userIds![i]).observeSingleEvent(of: .value, with: { (snapshot) in
                        let profile = CookingProfile(snapshot: snapshot)
                        conversation.users![i] = profile
                        if !conversation.users!.contains(where: {(profile) in return profile == nil}) {
                            if let index = self.conversations.index(where: {$0.id == conversation.id}) {
                            self.conversations[index] = conversation
                            self.checkForUnreadConversations()
                            self.tableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
                            }
                        }
                    })
                    
                }
            }
            
        })
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return conversations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCellID", for: indexPath) as! ConversationsCell
        
        cell.conversation = conversations[indexPath.row]
        let profile = conversations[indexPath.row].allOtherUsers?[0]
        if let imageURL = profile?.profileImageURL {
            cell.profileimageView.setImage(withUrl: imageURL, placeholder: UIImage(named: "Placeholder"), crossFadePlaceholder: true, cacheScaled: false, completion: { instance, error in
                profile?.profileImage = instance?.image
                cell.profileimageView.layer.add(CATransition(), forKey: nil)
            })
            
            
        }

        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let chatVc = segue.destination as! ChatViewController
        let cell = sender as! ConversationsCell
        chatVc.conversation = cell.conversation!
        chatVc.senderId = FIRAuth.auth()?.currentUser?.uid
        chatVc.senderDisplayName = user.displayName
    }

}
