//
//  TabBarController.swift
//  LovFood
//
//  Created by Nikolai Kratz on 12.07.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import GeoFire






class TabBarController: UITabBarController {

    
    
   
    var locationQuery = GFCircleQuery()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0...13 {
            cookingEventsArrays.append([CookingEvent]())
        }

    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        print("tabVCviewWillAppear")

        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print("tabVCviewDidApppear")
        locationQuery = geoFire.queryAtLocation(currentUserLocation, withRadius: 10.0)
        for i in 0...13{
            addDBObserverFor(i)
        }
    
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        print("tabVCviewWillDisappear")

        locationQuery.removeAllObservers()
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func addDBObserverFor(dayIndex :Int) {
        let date = NSDate().dateByAddingTimeInterval((60*60*(24))*Double(dayIndex))
  
        // Get all CookingEventIDs Nearby
        locationQuery.observeEventType(.KeyEntered, withBlock: { (key: String!, location: CLLocation!) in
       
            // Check if CookingEventID is in cookingEventsByDateDB
                cookingEventsByDateDBRef
                .child(convertNSDateToString(date)!)
                .child(key)
                .observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let _ = snapshot.value as? NSNumber {
                        
                        self.filterGender(snapshot.key) {
                            self.filterOccasion(snapshot.key) {
                            // Get CookingEvent
                            cookingEventsDBRef
                                .child(snapshot.key)
                                .observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                                    if snapshot.value != nil {
                                        let cookingEvent = CookingEvent(snapshot: snapshot)
                                        
                                        //Get User of CookingEvent
                                        if let userId = cookingEvent.userId {
                                            usersDBRef.child(userId)
                                                .observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                                                    let profile = CookingProfile(snapshot: snapshot)
                                                    cookingEvent.profile = profile
                                                    
                                                    // Add CookingEvent to Array
                                                    let index = cookingEventsArrays[dayIndex].indexOf { $0.eventId == cookingEvent.eventId}
                                                    if index == nil { cookingEventsArrays[dayIndex].append(cookingEvent) }
                                                    
                                                })
                                        }
                                        
                                    }
                                })
                        }
                        }
                    }
                })
            
        })
        
        locationQuery.observeEventType(.KeyExited, withBlock: { (key: String!, location: CLLocation!) in
            
            let index = cookingEventsArrays[dayIndex].indexOf { $0.eventId == key}
            if index != nil {
                print(index!)
                cookingEventsArrays[dayIndex].removeAtIndex(index!)
                
            }
        })
        

        
        
    }
    

    func filterGender(cookingEventId :String, completion: Void -> Void) {
        switch filter.gender {
        case .Male:
            cookingEventsByHostGenderDBRef
                .child("Male")
                .child(cookingEventId)
                .observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let _ = snapshot.value as? NSNumber {
                        completion()
                    }
                })
        case .Female:
            cookingEventsByHostGenderDBRef
                .child("Female")
                .child(cookingEventId)
                .observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let _ = snapshot.value as? NSNumber {
                        completion()
                    }
                })
        case .None: completion()
        }
    }
    
  
    func filterOccasion(cookingEventId :String, completion: Void -> Void) {
        switch filter.cookingOccasion {
        case .CandleLightDinner?:
            cookingEventsByOccasionDBRef
                .child("CandleLightDinner")
                .child(cookingEventId)
                .observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let _ = snapshot.value as? NSNumber {
                        completion()
                    }
                })
        case .CookingTogether?:
            cookingEventsByOccasionDBRef
                .child("CookingTogether")
                .child(cookingEventId)
                .observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let _ = snapshot.value as? NSNumber {
                        completion()
                    }
                })
        case .CommercialDining?:
            cookingEventsByOccasionDBRef
                .child("CommercialDining")
                .child(cookingEventId)
                .observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    if let _ = snapshot.value as? NSNumber {
                        completion()
                    }
                })
        case nil: completion()
        }
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
