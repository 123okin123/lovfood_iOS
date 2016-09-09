//
//  MyEventsViewControllerCollectionViewController.swift
//  LovFood
//
//  Created by Nikolai Kratz on 28.05.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import MapKit
import GeoFire
import MapleBacon

private let reuseIdentifier = "MyEventsCellID"

class MyEventsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
   
    var cookingEvents = [CookingEvent]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.delegate = self
        addDatabaseObserver()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addDatabaseObserver() {
        let query = cookingEventsDBRef.queryOrderedByChild("userId").queryEqualToValue(user.uid)
        query.observeEventType(.ChildAdded, withBlock: { (snapshot) in
        let cookingEvent = CookingEvent(snapshot: snapshot)
        cookingEvent.profile = userCookingProfile!
        self.cookingEvents.append(cookingEvent)
        
        let index = self.cookingEvents.indexOf{$0.eventId == cookingEvent.eventId}
        self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: index!, inSection: 0)])
        })
        query.observeEventType(.ChildRemoved, withBlock: { (snapshot) in
            let cookingEvent = CookingEvent(snapshot: snapshot)
            let index = self.cookingEvents.indexOf{$0.eventId == cookingEvent.eventId}
            self.cookingEvents.removeAtIndex(index!)
            self.collectionView?.deleteItemsAtIndexPaths([NSIndexPath(forItem: index!, inSection: 0)])
        })
        query.observeEventType(.ChildChanged, withBlock: { (snapshot) in
            let cookingEvent = CookingEvent(snapshot: snapshot)
            let index = self.cookingEvents.indexOf{$0.eventId == cookingEvent.eventId}
            self.cookingEvents.removeAtIndex(index!)
            self.cookingEvents.insert(cookingEvent, atIndex: index!)
            self.collectionView?.reloadItemsAtIndexPaths([NSIndexPath(forItem: index!, inSection: 0)])
        })
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cookingEvents.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MyEventCell
        let cookingEvent = cookingEvents[indexPath.row]
  

        cell.cookingEventTitleLabel.text = cookingEvent.title
        cell.cookingEventDateLabel.text = convertNSDateToString(cookingEvent.eventDate)
        cell.tag = indexPath.row
        
        if let image = cookingEvents[indexPath.row].image {
            cell.cookingEventImageView.image = image
        } else {
            if let imageURL = cookingEvent.imageURL {
                cell.cookingEventImageView.setImageWithURL(imageURL, placeholder: UIImage(named: "Placeholder"), crossFadePlaceholder: true, cacheScaled: false, completion: { instance, error in
                    self.cookingEvents[indexPath.row].image = instance?.image
                    cell.cookingEventImageView.layer.addAnimation(CATransition(), forKey: nil)
                })
                
                
            }
        }
        

        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: screenwidth - 20, height: 200)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 20
    }
    
    
    
    @IBAction func canceledFromCreateEventUnwindSegue(segue:UIStoryboardSegue) {
        
    }
    
    
    @IBAction func savedFromCreateEventUnwindSegue(segue:UIStoryboardSegue) {
      
        let createEventVC = segue.sourceViewController as! CreateEventViewController
        let cookingEvent = createEventVC.cookingEvent
 
  

        var lat = 1.0
        var long = 1.0
        if let location = currentUserLocation {
        lat = location.coordinate.latitude
        long = location.coordinate.longitude
        }
        //for _ in 0...20 {
        // Creat Event
        let cookingEventRef = dataBaseRef.child("cookingEvents").childByAutoId()
        let cookingEventDictionary :NSDictionary = [
            "title" : cookingEvent.title!,
            "description" : cookingEvent.description!,
            "userId" : user!.uid,
            "eventDate" : convertNSDateToString(cookingEvent.eventDate)!,
            "eventTime" : convertNSDateTimeToString(cookingEvent.eventDate)!,
            "coordinates" : [
                "lat": lat,
                "long": long,
            ],
            "occasion" : cookingEvent.occasion!.rawValue,
            "price" : 10,
            "imageURL" : String(cookingEvent.imageURL!)
        ]
        cookingEventRef.setValue(cookingEventDictionary)
        dataBaseRef.child("cookingEventsByDate")
            .child(convertNSDateToString(cookingEvent.eventDate)!)
            .child(cookingEventRef.key)
            .setValue(true)
        dataBaseRef.child("cookingEventsByOccasion")
            .child(cookingEvent.occasion!.rawValue)
            .child(cookingEventRef.key)
            .setValue(true)
        dataBaseRef.child("cookingEventsByHostGender")
            .child((userCookingProfile?.gender?.rawValue)!)
            .child(cookingEventRef.key)
            .setValue(true)
        geoFire.setLocation(currentUserLocation, forKey: cookingEventRef.key)
        

        
//   }
    }
        


    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cookingEvent = cookingEvents[indexPath.row]
        cookingEventsDBRef.child(cookingEvent.eventId!).removeValue()
        cookingEventsByDateDBRef.child(convertNSDateToString(cookingEvent.eventDate!)!).child(cookingEvent.eventId!).removeValue()
        cookingEventsByHostGenderDBRef.child(userCookingProfile!.gender!.rawValue).child(cookingEvent.eventId!).removeValue()
        cookingEventsByOccasionDBRef.child(cookingEvent.occasion!.rawValue).child(cookingEvent.eventId!).removeValue()
        geofireRef.child(cookingEvent.eventId!).removeValue()
    }
    
    

    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /*
        if segue.identifier == "showDetailVCFromMyEventsSegueID" {
            if let cookingOfferDetailVC = segue.destinationViewController as? CookingOfferDetailViewController {
                if let cell = sender as? MyEventCell {
                    cookingOfferDetailVC.cookingEvent = cookingEvents[cell.tag]
                }
            }
        }
 */
    }

}
