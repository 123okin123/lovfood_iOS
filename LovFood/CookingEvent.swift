//
//  CookingEvent.swift
//  LovFood
//
//  Created by Nikolai Kratz on 24.04.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Firebase

open class CookingEvent {
    
    var title :String?
    var description :String?
    var profile :CookingProfile?
    var eventId :String?
    var userId :String?
    var eventDate: Date?
    var coordinates: CLLocationCoordinate2D?
    var image :UIImage?
    var imageURL :URL?
    
    var distance: CLLocationDistance? {get {
        if currentUserLocation != nil && coordinates != nil {
            let eventLocation = CLLocation(latitude: coordinates!.latitude, longitude: coordinates!.longitude)
            let userLocation = currentUserLocation!
             return eventLocation.distance(from: userLocation)
        } else { return nil}
    }}
 
    var occasion :Occasion?
    
    var price :Double?
    
    
    var attendeesCount :Int?
    var usesVideo = false
    
    init() {}
    
    init(title: String, description: String, profile: CookingProfile, userId :String, eventId : String, eventDate: Date, occasion :Occasion, coordinates: CLLocationCoordinate2D) {
    self.title = title
    self.description = description
    self.userId = userId
    self.eventId = eventId
    self.profile = profile
    self.eventDate = eventDate
    self.occasion = occasion
    self.coordinates = coordinates
    }
    init(snapshot: FIRDataSnapshot) {
    self.title = (snapshot.value as! NSDictionary)["title"] as? String
    self.description = (snapshot.value as! NSDictionary)["description"] as? String
    self.userId = (snapshot.value as! NSDictionary)["userId"] as? String
    self.eventId = snapshot.key 
    self.eventDate = convertStringToNSDate((snapshot.value as! NSDictionary)["eventDate"] as? String)
    let latitude = ((snapshot.value as! NSDictionary)["coordinates"]as! NSDictionary)["lat"] as? Double
    let longitude = ((snapshot.value as! NSDictionary)["coordinates"] as! NSDictionary)["long"] as? Double
        if latitude != nil && longitude != nil {
            self.coordinates = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        }
    if let imageURLString = (snapshot.value as! NSDictionary)["imageURL"] as? String {
            self.imageURL = URL(string: imageURLString)
    }
    if let occasionRawValue = (snapshot.value as! NSDictionary)["occasion"] as? String {
        switch occasionRawValue {
        case "CandleLightDinner": occasion = .CandleLightDinner
        case "CookingTogether": occasion = .CookingTogether
        case "CommercialDining": occasion = .CommercialDining
        default: break
        }
    }
    }
    


}



public func convertStringToNSDate(_ string: String?) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
    var date :Date?
    if string != nil {
    date = dateFormatter.date(from: string!)
    }
    return date
}

public func convertNSDateToString(_ date: Date?) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
    var string :String?
    if date != nil {
    string = dateFormatter.string(from: date!)
    }
    return string
}

public func convertStringToNSDateTime(_ string: String?) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    var date :Date?
    if string != nil {
    date = dateFormatter.date(from: string!)
    }
    return date
}

public func convertNSDateTimeToString(_ date: Date?) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    var string :String?
    if date != nil {
    string = dateFormatter.string(from: date!)
    }
    return string
}



public enum Occasion :String {
    case CandleLightDinner
    case CookingTogether
    case CommercialDining
}








