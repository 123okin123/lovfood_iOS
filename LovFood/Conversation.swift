//
//  Conversation.swift
//  LovFood
//
//  Created by Nikolai Kratz on 19.09.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import Foundation
import Firebase

class Conversation {
    var id :String?
    var lastMessage :String?
    var lastMessagedate :Date?
    var userIds : [String]?
    var users : [CookingProfile?]?
    var allOtherUsers : [CookingProfile?]? {get{
        return users?.filter({$0?.userId != user.uid})
        }}
    
    init(snapshot :FIRDataSnapshot) {
    self.id = snapshot.key
    self.lastMessage = (snapshot.value as! NSDictionary)["lastMessage"] as? String
    let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd hh:mm a"
        if let dateString = (snapshot.value as! NSDictionary)["lastMessageDate"] as? String {
        self.lastMessagedate = dateFormatter.date(from: dateString)
        }
    self.userIds = (((snapshot.value as! NSDictionary)["users"] as! NSDictionary).allKeys as? [String])
    }
}
