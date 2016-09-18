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
    var locationString: String?
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
        
    let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd hh:mm a"

        
    self.title = (snapshot.value as! NSDictionary)["title"] as? String
    self.description = (snapshot.value as! NSDictionary)["description"] as? String
    self.userId = (snapshot.value as! NSDictionary)["userId"] as? String
    self.eventId = snapshot.key
    let dateString = (snapshot.value as! NSDictionary)["eventDate"] as! String
    let timeString = (snapshot.value as! NSDictionary)["eventTime"] as! String
    self.eventDate = dateFormatter.date(from: (dateString + " " + timeString))
    let latitude = ((snapshot.value as! NSDictionary)["coordinates"]as! NSDictionary)["lat"] as? Double
    let longitude = ((snapshot.value as! NSDictionary)["coordinates"] as! NSDictionary)["long"] as? Double
        if latitude != nil && longitude != nil {
            self.coordinates = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        }
    self.locationString = (snapshot.value as! NSDictionary)["locationString"] as? String
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





public enum Occasion :String {
    case CandleLightDinner
    case CookingTogether
    case CommercialDining
}








