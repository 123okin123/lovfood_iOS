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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addDatabaseObserver() {
        let query = cookingEventsDBRef.queryOrdered(byChild: "userId").queryEqual(toValue: user.uid)
        query.observe(.childAdded, with: { (snapshot) in
        let cookingEvent = CookingEvent(snapshot: snapshot)
        cookingEvent.profile = userCookingProfile!
        self.cookingEvents.append(cookingEvent)
        
        let index = self.cookingEvents.index{$0.eventId == cookingEvent.eventId}
        self.collectionView?.insertItems(at: [IndexPath(item: index!, section: 0)])
        })
        query.observe(.childRemoved, with: { (snapshot) in
            let cookingEvent = CookingEvent(snapshot: snapshot)
            let index = self.cookingEvents.index{$0.eventId == cookingEvent.eventId}
            self.cookingEvents.remove(at: index!)
            self.collectionView?.deleteItems(at: [IndexPath(item: index!, section: 0)])
        })
        query.observe(.childChanged, with: { (snapshot) in
            let cookingEvent = CookingEvent(snapshot: snapshot)
            let index = self.cookingEvents.index{$0.eventId == cookingEvent.eventId}
            self.cookingEvents.remove(at: index!)
            self.cookingEvents.insert(cookingEvent, at: index!)
            self.collectionView?.reloadItems(at: [IndexPath(item: index!, section: 0)])
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cookingEvents.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyEventCell
        let cookingEvent = cookingEvents[(indexPath as NSIndexPath).row]
  
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none

        cell.cookingEventTitleLabel.text = cookingEvent.title
        cell.cookingEventDateLabel.text = dateFormatter.string(for: cookingEvent.eventDate)
        cell.tag = (indexPath as NSIndexPath).row
        
        if let image = cookingEvents[(indexPath as NSIndexPath).row].image {
            cell.cookingEventImageView.image = image
        } else {
            if let imageURL = cookingEvent.imageURL {
                cell.cookingEventImageView.setImage(withUrl: imageURL, placeholder: UIImage(named: "Placeholder"), crossFadePlaceholder: true, cacheScaled: false, completion: { instance, error in
                    if self.cookingEvents.indices.contains(indexPath.row) {
                        self.cookingEvents[indexPath.row].image = instance?.image
                        cell.cookingEventImageView.layer.add(CATransition(), forKey: nil)

                    }
                })
                
                
            }
        }
        

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenwidth - 20, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    
    
    @IBAction func canceledFromCreateEventUnwindSegue(_ segue:UIStoryboardSegue) {
        
    }
    
    
    @IBAction func savedFromCreateEventUnwindSegue(_ segue:UIStoryboardSegue) {
        
        let createEventVC = segue.source as! CreateEventViewController
        let cookingEvent = createEventVC.cookingEvent
        
        
        
        var lat = 1.0
        var long = 1.0
        if let location = currentUserLocation {
            lat = location.coordinate.latitude
            long = location.coordinate.longitude

            CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
                
                if error != nil {
                    print("Reverse geocoder failed with error" + (error!.localizedDescription))
                    return
                }
                
                if placemarks!.count > 0 {
                    let pm = placemarks![0]
                    
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy_MM_dd"
                    let date = dateFormatter.string(from: cookingEvent.eventDate!)
                    
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "hh:mm"
                    let time = timeFormatter.string(from: cookingEvent.eventDate!)
                    
                    
                    
                    //for _ in 0...20 {
                    // Creat Event
                    let cookingEventRef = dataBaseRef.child("cookingEvents").childByAutoId()
                    let cookingEventDictionary :NSDictionary = [
                        "title" : cookingEvent.title!,
                        "description" : cookingEvent.description!,
                        "userId" : user!.uid,
                        "eventDate" : date,
                        "eventTime" : time,
                        "coordinates" : [
                            "lat": lat,
                            "long": long,
                        ],
                        "locationString" : pm.subAdministrativeArea!,
                        "occasion" : cookingEvent.occasion!.rawValue,
                        "price" : 10,
                        "imageURL" : String(describing: cookingEvent.imageURL!)
                    ]
                    cookingEventRef.setValue(cookingEventDictionary)
                    dataBaseRef.child("cookingEventsByDate")
                        .child(date)
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
                    geoFire?.setLocation(currentUserLocation, forKey: cookingEventRef.key)
                    
                    
                    
                    //   }
                    
                    
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            })
            
        }
    }
        


    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cookingEvent = cookingEvents[(indexPath as NSIndexPath).row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy_MM_dd"
        
        
        cookingEventsDBRef.child(cookingEvent.eventId!).removeValue()
        cookingEventsByDateDBRef.child(dateFormatter.string(from: (cookingEvent.eventDate!))).child(cookingEvent.eventId!).removeValue()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
