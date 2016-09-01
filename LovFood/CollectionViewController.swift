//
//  CollectionViewController.swift
//  LovFood
//
//  Created by Nikolai Kratz on 24.04.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import GeoFire

private let reuseIdentifier = "cookingOfferCellID"


class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate  {
    

    var todayDate = NSDate()
 
    var locationManager = (UIApplication.sharedApplication().delegate as! AppDelegate).locationManager

    
    
    var timer = NSTimer.init()



 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CollectionVCviewDidLoad")

        
        navigationItem.titleView = UIImageView(image: UIImage(named: "logoInApp"))
        self.collectionView?.delegate = self

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationService()
        updateUI()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(CollectionViewController.updateUI), userInfo: nil, repeats: true)

        print(cookingEventsArrays)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("CollectionVCviewDidDisappear")
        
        timer.invalidate()
        
    }
   
   


    
    func checkLocationService() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            if let retrievedUserLocation = locationManager.location  {
                currentUserLocation = retrievedUserLocation
                print("location Service allowed, and location \(currentUserLocation) available")
            } else {
                
                print("location Service allowed, but no location available")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let weAreUpdationLocationVC = storyboard.instantiateViewControllerWithIdentifier("weAreUpdationLocationVCID")
                self.presentViewController(weAreUpdationLocationVC, animated: true, completion: nil)
                
            }
            
        } else {
            print("location Service not allowed")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let weNeedYourLocationVC = storyboard.instantiateViewControllerWithIdentifier("weNeedYourLocationVCID")
            self.presentViewController(weNeedYourLocationVC, animated: true, completion: nil)
            
        }
    }
    

    
    

    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showDetailVCSegueID" {
        if let cookingOfferDetailVC = segue.destinationViewController as? CookingOfferDetailViewController {
            if let cell = sender as? UICollectionViewCell {
                let indexPath = collectionView!.indexPathForCell(cell)!
                cookingOfferDetailVC.cookingEvent = cookingEventsArrays[indexPath.section][indexPath.row]
            }
        }
        }
        
        if segue.identifier == "showFiltersSegueID" {
            if let navVC = segue.destinationViewController as? UINavigationController {
                if let filterVC = navVC.viewControllers[0] as? FilterTableViewController {
                
                }
            }
        }

        
        
    }
    
    @IBAction func backFromMapUnwindSegue(segue:UIStoryboardSegue) {
    }
    
    @IBAction func backFromFiltersUnwindSegue(segue:UIStoryboardSegue) {

       
        /*
        let filterVC = segue.sourceViewController as! FilterTableViewController
        filter = filterVC.filter
        filteredCookingOffers.removeAll(keepCapacity: false)
        
        filteredCookingOffers = cookingEvents
        if  filter.cookingOccasion != nil {
        let occesionPredicate = NSPredicate(format: "SELF = \(filter.cookingOccasion!.hashValue)")
        filteredCookingOffers = filteredCookingOffers.filter {
            occesionPredicate.evaluateWithObject($0.occasion.hashValue)
             }
        filtered = true
        } else {
        filtered = false
        }
        if filter.gender != nil {
        let genderPredicate = NSPredicate(format: "SELF = \(filter.gender!.hashValue)")
        filteredCookingOffers = filteredCookingOffers.filter { genderPredicate.evaluateWithObject($0.profile.gender?.hashValue) }
        filtered = true
        } else {
            filtered = false
        }
        
        
        
        
        collectionView?.reloadData()
        */
        
        
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: screenwidth, height: 140)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    

    
    

    // MARK: UICollectionViewDataSource


    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "collectionHeaderID", forIndexPath: indexPath) as! HeaderCollectionReusableView
        
        if !(cookingEventsArrays.isEmpty) {
        if !(cookingEventsArrays[indexPath.section].isEmpty) {
            let firstCookingEvent = cookingEventsArrays[indexPath.section][0]
            let dateFormater = NSDateFormatter()
            dateFormater.dateStyle = .ShortStyle
            dateFormater.timeStyle = .NoStyle
            if let date = firstCookingEvent.eventDate as NSDate! {
            let dateString = dateFormater.stringFromDate(date)
            switch dateString {
            case dateFormater.stringFromDate(todayDate): headerView.label.text = "Today"
            case dateFormater.stringFromDate(todayDate.dateByAddingTimeInterval(60*60*24)): headerView.label.text = "Tomorrow"
            default:
                headerView.label.text = dateString
            }
            }
        } else {
            headerView.label.text = ""
            }
        }
           return headerView

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if cookingEventsArrays[section].isEmpty {
        return CGSize(width: 0, height: 0)
        } else {
        return CGSize(width: screenwidth, height: 50)
        }
        
        
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return cookingEventsArrays.count
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cookingEventsArrays[section].count
    }

    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
     
        if  indexPath.section == (cookingEventsArrays.endIndex - 1) {
            print("reached endsection \(cookingEventsArrays.endIndex - 1)")
 
        }
    
    }
 

    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CookingOfferCell
        let cookingEvent = cookingEventsArrays[indexPath.section][indexPath.row]
        
       
        cell.cookingOfferTitle.text = cookingEvent.title
        

        if let distance = cookingEvent.distance {
        cell.cookingOfferDistance.text = "\(Int(distance)/1000) km"
        }
        
        if let occasion = cookingEvent.occasion {
        switch occasion {
        case .CandleLightDinner:
            cell.candelLightDinnerIndicator.hidden = false
            cell.candelLightDinnerIndicator.image = UIImage(named: "restaurant")
        case .CookingTogether:
            cell.candelLightDinnerIndicator.hidden = true
        case .CommercialDining:
            cell.candelLightDinnerIndicator.hidden = false
            cell.candelLightDinnerIndicator.image = UIImage(named: "heart")
        }
        }
        
        
        if let profile = cookingEvent.profile {
        cell.profileName.text = profile.firstName
        
        if let image = profile.profileImage as UIImage? {
            cell.profileImage.image = image
        } else {
            if let profileImageURL = profile.profileImageURL {
                let request = NSMutableURLRequest(URL: profileImageURL)
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                    if error != nil {
                        print("thers an error in the log")
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            profile.profileImage = UIImage(data: data!)
                            cell.profileImage.image = profile.profileImage
                            
                            
                        }
                        
                    }
                }
                task.resume()
            }
        }
        
        if  profile.smallprofileImage == nil {
            let request = NSMutableURLRequest(URL: profile.profileSmallImageURL!)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                if error != nil {
                    print("thers an error in the log")
                } else {
                    dispatch_async(dispatch_get_main_queue()) {
                        profile.smallprofileImage = UIImage(data: data!)
                    }
                }
            }
            task.resume()
        }
        //cookingEvent.profile = profile
        }
            
            
        cell.tag = indexPath.row
        return cell
    }
    

    


    
    
    

    func updateUI() {
        collectionView?.reloadData()
    }
    

    
    
   
    // MARK: UICollectionViewDelegate

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

}
