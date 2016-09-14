//
//  CookingProfile.swift
//  LovFood
//
//  Created by Nikolai Kratz on 11.05.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import Foundation
import UIKit
import Firebase

open class CookingProfile {
    var firstName :String?
    var lastName :String?
    var userName :String?
    var email :String?
    
    var profileImageURL :URL?
    var profileSmallImageURL :URL?
    
    var profileText :String?
    var profileImage :UIImage?
    var smallprofileImage : UIImage?
    var gender :Gender?
    
    var commercial = false
    
    
    init(){}
    
    init(snapshot: FIRDataSnapshot) {
    self.firstName = (snapshot.value as! NSDictionary)["firstname"] as? String
    self.lastName = (snapshot.value as! NSDictionary)["lastname"] as? String
    self.userName = (snapshot.value as! NSDictionary)["username"] as? String
    self.email = (snapshot.value as! NSDictionary)["email"] as? String
    if let profileImageURLString = (snapshot.value as! NSDictionary)["profileImageURL"] as? String {
            self.profileImageURL = URL(string: profileImageURLString)
    }
    if let profileSmallImageURLString = (snapshot.value as! NSDictionary)["profileSmallImageURL"] as? String {
            self.profileSmallImageURL = URL(string: profileSmallImageURLString)
    }
    if let genderString = (snapshot.value as! NSDictionary)["gender"] as? String {
        switch genderString {
        case "male": gender = .Male
        case "female": gender = .Female
        default: gender = .none
        }
    }
    }
}




public enum Gender :String {
    case Male
    case Female
    case None
}
