//
//  WeNeedYourLocationViewController.swift
//  LovFood
//
//  Created by Nikolai Kratz on 22.07.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import MapKit

class WeNeedYourLocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var openSettingsButton: UIButton! {didSet{
        openSettingsButton.layer.borderColor = UIColor.whiteColor().CGColor
        openSettingsButton.layer.borderWidth = 1
        openSettingsButton.layer.cornerRadius = 5
        }}
    
    
    
    var locationManager = (UIApplication.sharedApplication().delegate as! AppDelegate).locationManager
    
    @IBAction func openSettingsButtonPressed(sender: UIButton) {
        let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
        if let url = settingsUrl {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
        locationManager.requestLocation()
        } else {
        locationManager.requestWhenInUseAuthorization()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
          locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        if !(locations.isEmpty) {
        currentUserLocation = locations.last!
            if let tabBarC = presentingViewController as? TabBarController {
                if let navVC = tabBarC.viewControllers![0] as? UINavigationController {
                    if let collectionVC = navVC.viewControllers[0] as? CollectionViewController {
                        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
            }
        
        }
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        locationManager.requestLocation()
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
