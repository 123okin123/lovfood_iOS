//
//  MapViewController.swift
//  LovFood
//
//  Created by Nikolai Kratz on 19.05.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var centerLocationButton: CenterLocationButton!
 
    
    
    
    @IBAction func centerLocationButton(sender: CenterLocationButton) {
            if mapView.showsUserLocation {
                let coordinate = mapView.userLocation.coordinate
                if coordinate.latitude != 0 &&  coordinate.longitude != 0 {
                    mapView.setCenterCoordinate(coordinate, animated: true)
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        if currentUserLocation != nil {
        let coordinateRegion = MKCoordinateRegion(center: currentUserLocation!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.27641499701561401, longitudeDelta: 0.25749207818395803))
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
        }
  
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
     
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    func refreshMapView() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        if !(cookingEventsArrays.isEmpty) {
        for i in 0...cookingEventsArrays.count - 1 {
            if !(cookingEventsArrays[i].isEmpty) {
            for j in 0...cookingEventsArrays[i].count - 1 {
                if let coordinates = cookingEventsArrays[i][j].coordinates {
            let mapAnnotation = MapAnnotation(title: cookingEventsArrays[i][j].profile?.firstName, subtitle: cookingEventsArrays[i][j].title, coordinate: coordinates, image: cookingEventsArrays[i][j].profile?.smallprofileImage, cookingEvent: cookingEventsArrays[i][j])
            self.mapView.addAnnotation(mapAnnotation)
                }
            }
            }
        }
        }
    
    }

    
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.region)
        if round(mapView.centerCoordinate.latitude * 100) == round(mapView.userLocation.coordinate.latitude * 100) && round(mapView.centerCoordinate.longitude * 100) == round(mapView.userLocation.coordinate.longitude * 100) {
            centerLocationButton.selected = true
        } else {
            centerLocationButton.selected = false
        }
    }
    
    func mapViewDidFinishRenderingMap(mapView: MKMapView, fullyRendered: Bool) {
        refreshMapView()
    }

    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "annoID"

        if let annotation = annotation as? MapAnnotation {
            
            let cookingEvent = annotation.cookingEvent
            let profile = cookingEvent!.profile
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            
            if annotationView == nil {
                
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
                annotationView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)

            } else {
                
                annotationView?.annotation = annotation
            }
            
            if let image = profile?.profileImage as UIImage? {
                profile?.profileImage = image
            } else {
                if let url = profile?.profileImageURL as NSURL! {
                let request = NSMutableURLRequest(URL: url)
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                    if error != nil {
                        print("thers an error in the log")
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            profile?.profileImage = UIImage(data: data!)
                        }
                    }
                }
                
                task.resume()
                }
            }
            
            if let image = profile?.smallprofileImage as UIImage? {
                print("annotaion has profile pic")
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                imageView.image = image
                imageView.layer.cornerRadius = imageView.frame.size.width / 2
                imageView.contentMode = .ScaleToFill
                annotationView?.leftCalloutAccessoryView = imageView
            } else {
                print("annotaion has no profile pic")
                if let url = profile?.profileSmallImageURL as NSURL! {
                let request = NSMutableURLRequest(URL: url)
                let session = NSURLSession.sharedSession()
                let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                    if error != nil {
                        print("thers an error in the log")
                    } else {
                        dispatch_async(dispatch_get_main_queue()) {
                            print("profile pic of annotaion loaded")
                            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                            imageView.image = profile?.smallprofileImage
                            imageView.layer.cornerRadius = imageView.frame.size.width / 2
                            imageView.contentMode = .ScaleToFill
                            annotationView?.leftCalloutAccessoryView = imageView

                        }
                    }
                }
                task.resume()
                }
            }

            
            switch profile?.gender {
            case .Male?: annotationView!.image = UIImage(named: "cookinghat_male")
            case .Female?: annotationView!.image = UIImage(named: "cookinghat_selected")
            case .None?: annotationView!.image = UIImage(named: "restaurant")
            case nil: break
            }

            return annotationView
        }
        return nil
    }
    
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
       let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("cookingOfferDetailVCID") as! CookingOfferDetailViewController
        if let annotation = view.annotation as? MapAnnotation {
 
                detailVC.cookingEvent = annotation.cookingEvent
        
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
    
    
    


    
    // MARK: - Navigation
    
    @IBAction func backFromMapFiltersUnwindSegue(segue:UIStoryboardSegue) {
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        

    }
    

}
