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
import MapleBacon

private let reuseIdentifier = "cookingOfferCellID"


class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate  {
    

    var todayDate = Date()
 
    var locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager

    
    
    var timer = Timer.init()



 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CollectionVCviewDidLoad")

        
        navigationItem.titleView = UIImageView(image: UIImage(named: "logoInApp"))
        self.collectionView?.delegate = self

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationService()
        updateUI()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(CollectionViewController.updateUI), userInfo: nil, repeats: true)

        print(cookingEventsArrays)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("CollectionVCviewDidDisappear")
        
        timer.invalidate()
        
    }
   
   


    
    func checkLocationService() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            if let retrievedUserLocation = locationManager.location  {
                currentUserLocation = retrievedUserLocation
                print("location Service allowed, and location \(currentUserLocation) available")
            } else {
                
                print("location Service allowed, but no location available")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let weAreUpdationLocationVC = storyboard.instantiateViewController(withIdentifier: "weAreUpdationLocationVCID")
                self.present(weAreUpdationLocationVC, animated: true, completion: nil)
                
            }
            
        } else {
            print("location Service not allowed")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let weNeedYourLocationVC = storyboard.instantiateViewController(withIdentifier: "weNeedYourLocationVCID")
            self.present(weNeedYourLocationVC, animated: true, completion: nil)
            
        }
    }
    

    
    

    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetailVCSegueID" {
        if let cookingOfferDetailVC = segue.destination as? CookingOfferDetailViewController {
            if let cell = sender as? UICollectionViewCell {
                let indexPath = collectionView!.indexPath(for: cell)!
                cookingOfferDetailVC.cookingEvent = cookingEventsArrays[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
            }
        }
        }
        
        if segue.identifier == "showFiltersSegueID" {
            if let navVC = segue.destination as? UINavigationController {
                if let filterVC = navVC.viewControllers[0] as? FilterTableViewController {
                
                }
            }
        }

        
        
    }
    
    @IBAction func backFromMapUnwindSegue(_ segue:UIStoryboardSegue) {
    }
    
    @IBAction func backFromFiltersUnwindSegue(_ segue:UIStoryboardSegue) {

       
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
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: screenwidth - 10, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    

    
    

    // MARK: UICollectionViewDataSource


    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "collectionHeaderID", for: indexPath) as! HeaderCollectionReusableView
        
        if !(cookingEventsArrays.isEmpty) {
        if !(cookingEventsArrays[(indexPath as NSIndexPath).section].isEmpty) {
            let firstCookingEvent = cookingEventsArrays[(indexPath as NSIndexPath).section][0]
            let dateFormater = DateFormatter()
            dateFormater.dateStyle = .short
            dateFormater.timeStyle = .none
            if let date = firstCookingEvent.eventDate as Date! {
            let dateString = dateFormater.string(from: date)
            switch dateString {
            case dateFormater.string(from: todayDate): headerView.label.text = "Today"
            case dateFormater.string(from: todayDate.addingTimeInterval(60*60*24)): headerView.label.text = "Tomorrow"
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if cookingEventsArrays[section].isEmpty {
        return CGSize(width: 0, height: 0)
        } else {
        return CGSize(width: screenwidth, height: 50)
        }
        
        
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return cookingEventsArrays.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cookingEventsArrays[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
     
        if  (indexPath as NSIndexPath).section == (cookingEventsArrays.endIndex - 1) {
            print("reached endsection \(cookingEventsArrays.endIndex - 1)")
 
        }
    
    }
 

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CookingOfferCell
        let cookingEvent = cookingEventsArrays[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        
       
        cell.cookingOfferTitle.text = cookingEvent.title
        

        if let distance = cookingEvent.distance {
        cell.cookingOfferDistance.text = "\(Int(distance)/1000) km"
        }
        
        if let occasion = cookingEvent.occasion {
        switch occasion {
        case .CandleLightDinner:
            cell.candelLightDinnerIndicator.isHidden = false
            cell.candelLightDinnerIndicator.image = UIImage(named: "heart")
        case .CookingTogether:
            cell.candelLightDinnerIndicator.isHidden = true
        case .CommercialDining:
            cell.candelLightDinnerIndicator.isHidden = false
            cell.candelLightDinnerIndicator.image = UIImage(named: "restaurant")
        }
        }
        
        // Check if cookingEvent has profile and load profileImage
        if let profile = cookingEvent.profile {
        cell.profileName.text = profile.firstName
       
        if let image = profile.profileImage as UIImage? {
            cell.profileImage.image = image
        
        } else {
            
            if let profileImageURL = profile.profileImageURL {
                let session = URLSession.shared
                let task = session.dataTask(with: profileImageURL, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        print("thers an error in the log")
                    } else {
                        DispatchQueue.main.async {
                            profile.profileImage = UIImage(data: data!)
                            cell.profileImage.image = profile.profileImage
                        
                            
                        }
                        
                    }
                }) 
                task.resume()
            } else {
                profile.profileImage = nil
                cell.profileImage.image = nil
            }
        }

        if  profile.smallprofileImage == nil {
            if let profileSmallImageURL = profile.profileSmallImageURL {
            let session = URLSession.shared
            let task = session.dataTask(with: profileSmallImageURL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print("thers an error in the log")
                } else {
                    DispatchQueue.main.async {
                        profile.smallprofileImage = UIImage(data: data!)
                    }
                }
            }) 
            task.resume()
            }
        }
        }
        
        // END OF: Check if cookingEvent has profile and load profileImage
        if let image = cookingEventsArrays[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row].image {
            
            cell.cookingOfferImageView.image = image
        } else {
            
            if let imageURL = cookingEvent.imageURL {
                print("ping3")
                cell.cookingOfferImageView.setImage(withUrl: imageURL, placeholder: UIImage(named: "Placeholder"), crossFadePlaceholder: true, cacheScaled: false, completion: { instance, error in
                    cookingEventsArrays[indexPath.section][indexPath.row].image = instance?.image
                    cell.cookingOfferImageView.layer.add(CATransition(), forKey: nil)
                })

            
            }
        }
     
        
        
        cell.tag = (indexPath as NSIndexPath).row
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
