//
//  WeAreUpdatingLocationViewController.swift
//  LovFood
//
//  Created by Nikolai Kratz on 22.07.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import MapKit

class WeAreUpdatingLocationViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var locationManager = (UIApplication.shared.delegate as! AppDelegate).locationManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestLocation()
        activityIndicator.startAnimating()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !(locations.isEmpty) {
            currentUserLocation = locations.last!
            if let tabBarC = presentingViewController as? TabBarController {
                if tabBarC.viewControllers![0] is CollectionViewController {
                    
                    presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
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
