//
//  PublicVariables.swift
//  LovFood
//
//  Created by Nikolai Kratz on 08.09.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GeoFire
import MapKit



public var screenwidth = UIScreen.main.bounds.size.width
public var screenheight = UIScreen.main.bounds.size.height
public var lovFoodColor = UIColor(red: 237/255, green: 52/255, blue: 81/255, alpha: 1)
public var lovFoodSecondaryColor = UIColor(red: 249/255, green: 247/255, blue: 244/255, alpha: 1)

public let dataBaseRef = FIRDatabase.database().reference()
public var user :FIRUser!
public var userDBRef :FIRDatabaseReference!
public var usersDBRef = dataBaseRef.child("users")
public let cookingEventsDBRef = dataBaseRef.child("cookingEvents")
public let cookingEventsByDateDBRef = dataBaseRef.child("cookingEventsByDate")
public let cookingEventsByHostGenderDBRef = dataBaseRef.child("cookingEventsByHostGender")
public let cookingEventsByOccasionDBRef = dataBaseRef.child("cookingEventsByOccasion")

public var filter = Filter()

public let storage = FIRStorage.storage()
public let storageRef = storage.reference(forURL: "gs://lovfood-1328.appspot.com")

public var currentUserLocation :CLLocation?
public var userCookingProfile :CookingProfile!

public var geofireRef = dataBaseRef.child("geoFire")
public var geoFire = GeoFire(firebaseRef: geofireRef)
public var cookingEventsArrays = [[CookingEvent]]()

public var chatDateFormat = "yyyy_MM_dd HH:mm:ss"

