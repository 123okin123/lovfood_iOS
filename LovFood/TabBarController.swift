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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("tabVCviewWillAppear")

        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("tabVCviewDidApppear")
        locationQuery = (geoFire?.query(at: currentUserLocation, withRadius: 10.0))!
        for i in 0...13{
            addDBObserverFor(i)
        }
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("tabVCviewWillDisappear")

        locationQuery.removeAllObservers()
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func addDBObserverFor(_ dayIndex :Int) {
        let date = Date().addingTimeInterval((60*60*(24))*Double(dayIndex))
  
        // Get all CookingEventIDs Nearby
        locationQuery.observe(.keyEntered, with: { (key: String?, location: CLLocation?) in
       
            // Check if CookingEventID is in cookingEventsByDateDB
                cookingEventsByDateDBRef
                .child(convertNSDateToString(date)!)
                .child(key!)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    if let _ = snapshot.value as? NSNumber {
                        
                        self.filterGender(snapshot.key) {
                            self.filterOccasion(snapshot.key) {
                            // Get CookingEvent
                            cookingEventsDBRef
                                .child(snapshot.key)
                                .observeSingleEvent(of: .value, with: { (snapshot) in
                                    if snapshot.value != nil {
                                        let cookingEvent = CookingEvent(snapshot: snapshot)
                                        
                                        //Get User of CookingEvent
                                        if let userId = cookingEvent.userId {
                                            usersDBRef.child(userId)
                                                .observeSingleEvent(of: .value, with: { (snapshot) in
                                                    let profile = CookingProfile(snapshot: snapshot)
                                                    cookingEvent.profile = profile
                                                    
                                                    // Add CookingEvent to Array
                                                    let index = cookingEventsArrays[dayIndex].index { $0.eventId == cookingEvent.eventId}
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
        
        locationQuery.observe(.keyExited, with: { (key: String?, location: CLLocation?) in
            
            let index = cookingEventsArrays[dayIndex].index { $0.eventId == key}
            if index != nil {
                print(index!)
                cookingEventsArrays[dayIndex].remove(at: index!)
                
            }
        })
        

        
        
    }
    

    func filterGender(_ cookingEventId :String, completion: @escaping (Void) -> Void) {
        switch filter.gender {
        case .Male:
            cookingEventsByHostGenderDBRef
                .child("Male")
                .child(cookingEventId)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    if let _ = snapshot.value as? NSNumber {
                        completion()
                    }
                })
        case .Female:
            cookingEventsByHostGenderDBRef
                .child("Female")
                .child(cookingEventId)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    if let _ = snapshot.value as? NSNumber {
                        completion()
                    }
                })
        case .None: completion()
        }
    }
    
  
    func filterOccasion(_ cookingEventId :String, completion: @escaping (Void) -> Void) {
        switch filter.cookingOccasion {
        case .CandleLightDinner?:
            cookingEventsByOccasionDBRef
                .child("CandleLightDinner")
                .child(cookingEventId)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    if let _ = snapshot.value as? NSNumber {
                        completion()
                    }
                })
        case .CookingTogether?:
            cookingEventsByOccasionDBRef
                .child("CookingTogether")
                .child(cookingEventId)
                .observeSingleEvent(of: .value, with: { (snapshot) in
                    if let _ = snapshot.value as? NSNumber {
                        completion()
                    }
                })
        case .CommercialDining?:
            cookingEventsByOccasionDBRef
                .child("CommercialDining")
                .child(cookingEventId)
                .observeSingleEvent(of: .value, with: { (snapshot) in
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
