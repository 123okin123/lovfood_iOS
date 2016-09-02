//
//  AppDelegate.swift
//  LovFood
//
//  Created by Nikolai Kratz on 24.04.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import GeoFire

public var screenwidth = UIScreen.mainScreen().bounds.size.width
public var screenheight = UIScreen.mainScreen().bounds.size.height
public var lovFoodColor = UIColor(red: 233/255, green: 103/255, blue: 103/255, alpha: 1)
public var lovFoodSecondaryColor = UIColor(red: 249/255, green: 247/255, blue: 244/255, alpha: 1)

public let dataBaseRef = FIRDatabase.database().reference()
public var user :FIRUser!
public var userDBRef :FIRDatabaseReference!
public var usersDBRef = dataBaseRef.child("users")
public var cookingEventsDBRef = dataBaseRef.child("cookingEvents")
public var cookingEventsByDateDBRef = dataBaseRef.child("cookingEventsByDate")
public var cookingEventsByHostGenderDBRef = dataBaseRef.child("cookingEventsByHostGender")
public var cookingEventsByOccasionDBRef = dataBaseRef.child("cookingEventsByOccasion")
public var filter = Filter()

public var currentUserLocation :CLLocation?
public var userCookingProfile :CookingProfile!

public var geofireRef = dataBaseRef.child("geoFire")
public var geoFire = GeoFire(firebaseRef: geofireRef)
public var cookingEventsArrays = [[CookingEvent]]()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()
    

    
    
   
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        UINavigationBar.appearance().setBackgroundImage(UIImage(), forBarMetrics: .Default)
        UINavigationBar.appearance().shadowImage = UIImage(named: "navBarShadow")

        
        
        if let notification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {
            let aps = notification["aps"] as! [String: AnyObject]
            print("launched from notifications \(aps)")
        }
        
        // INIT Firebase
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true

        
        
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        

        
        FIRAuth.auth()?.addAuthStateDidChangeListener { auth, userToLoggin in
            if let userToLoggin = userToLoggin {
                
                print("addAuth successfull for user \(userToLoggin)")

                user = userToLoggin
              
                userDBRef = dataBaseRef.child("users").child(user.uid)
                userDBRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    print(snapshot)
                    if snapshot.exists(){
                        print("user is in DB")
                        user = userToLoggin
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabVC = storyboard.instantiateViewControllerWithIdentifier("tabBarControllerID") as! TabBarController
                        let snapshotView = self.window?.snapshotViewAfterScreenUpdates(true)
                        tabVC.view.addSubview(snapshotView!)
                        self.window!.rootViewController = tabVC
                        UIView.transitionWithView(self.window!, duration: 0.2, options: .CurveEaseIn, animations: {
                            snapshotView?.alpha = 0
                            }, completion: { done in
                                snapshotView?.removeFromSuperview()
                        })
                        
                        

                        userDBRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        print("getting user profle")
                        userCookingProfile = CookingProfile(snapshot: snapshot)

                        if let profileImageURLString = snapshot.value!["profileImageURL"] as? String {
                            let profileImageURL = NSURL(string: profileImageURLString)
                            let request = NSMutableURLRequest(URL: profileImageURL!)
                            let session = NSURLSession.sharedSession()
                            let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
                                if error != nil {
                                    print("thers an error in the log")
                                } else {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        print("getting users profile image")
                                        userCookingProfile?.profileImage = UIImage(data: data!)
                                    }
                                }
                            }
                            task.resume()
                        }
                      })
                        
                    } else {
                        print("user is not in DB")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let loginVC = storyboard.instantiateViewControllerWithIdentifier("loginViewControllerID") as! LoginViewController
                        let rootViewController = self.window!.rootViewController
                        rootViewController!.presentViewController(loginVC, animated: false, completion: nil)
                    }
                })
            } else {
                print("addAuth failed")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewControllerWithIdentifier("loginViewControllerID") as! LoginViewController
                let rootViewController = self.window!.rootViewController
                rootViewController!.presentViewController(loginVC, animated: false, completion: nil)
                
            }
            
            
            
        }
        
        
        


        

        
        window?.tintColor = UIColor(red: 233/255, green: 103/255, blue: 103/255, alpha: 1)
        //FACEBOOK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true

        

    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //FACEBOOK
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
  
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    

        

    
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != .None {
            application.registerForRemoteNotifications()
        }
        
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register:", error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                     fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
    }
    
    




        


}

