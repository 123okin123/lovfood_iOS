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




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager = CLLocationManager()
    

    
    
   
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage(named: "navBarShadow")
       

        
        
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: AnyObject] {
            let aps = notification["aps"] as! [String: AnyObject]
            print("launched from notifications \(aps)")
        }
        
        // INIT Firebase
        FIRApp.configure()
        FIRDatabase.database().persistenceEnabled = true

        
        
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        
        FIRAuth.auth()?.addStateDidChangeListener { auth, userToLoggin in
            if let userToLoggin = userToLoggin {
                
                print("addAuth successfull for user \(userToLoggin)")

                user = userToLoggin
              
                userDBRef = dataBaseRef.child("users").child(user.uid)
                userDBRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    print(snapshot)
                    if snapshot.exists(){
                        print("user is in DB")
                        user = userToLoggin
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabVC = storyboard.instantiateViewController(withIdentifier: "tabBarControllerID") as! TabBarController
                        let snapshotView = self.window?.snapshotView(afterScreenUpdates: true)
                        tabVC.view.addSubview(snapshotView!)
                        self.window!.rootViewController = tabVC
                        UIView.transition(with: self.window!, duration: 0.2, options: .curveEaseIn, animations: {
                            snapshotView?.alpha = 0
                            }, completion: { done in
                                snapshotView?.removeFromSuperview()
                        })
                        
                        

                        userDBRef.observeSingleEvent(of: .value, with: { (snapshot) in
                        print("getting user profle")
                        userCookingProfile = CookingProfile(snapshot: snapshot)

                        if let profileImageURLString = (snapshot.value as! NSDictionary)["profileImageURL"] as? String {
                            let profileImageURL = URL(string: profileImageURLString)
                            let session = URLSession.shared
                            let task = session.dataTask(with: profileImageURL!, completionHandler: { (data, response, error) -> Void in
                                if error != nil {
                                    print("thers an error in the log")
                                } else {
                                    DispatchQueue.main.async {
                                        print("getting users profile image")
                                        userCookingProfile?.profileImage = UIImage(data: data!)
                                    }
                                }
                            }) 
                            task.resume()
                        }
                      })
                        
                    } else {
                        print("user is not in DB")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let loginVC = storyboard.instantiateViewController(withIdentifier: "loginViewControllerID") as! LoginViewController
                        let rootViewController = self.window!.rootViewController
                        rootViewController!.present(loginVC, animated: false, completion: nil)
                    }
                })
            } else {
                print("addAuth failed")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginViewControllerID") as! LoginViewController
                let rootViewController = self.window!.rootViewController
                rootViewController!.present(loginVC, animated: false, completion: nil)
                
            }
            
            
            
        }
        
        
        


        

        
        window?.tintColor = lovFoodColor
        //FACEBOOK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true

        

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //FACEBOOK
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
  
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    

        

    
    
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            
        }
        
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = ""
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        print("Device Token:", tokenString)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register:", error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
    }
    
    




        


}

