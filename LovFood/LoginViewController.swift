//
//  LoginViewController.swift
//  LovFood
//
//  Created by Nikolai Kratz on 11.07.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase


class LoginViewController: UIViewController {

    @IBOutlet weak var appIconCenterYAlignmentConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var fbLoginButton: UIButton! {didSet{
        fbLoginButton.layer.borderColor = UIColor.white.cgColor
        fbLoginButton.layer.borderWidth = 1
        fbLoginButton.layer.cornerRadius = 5
        fbLoginButton.tintColor = UIColor.clear
        }}
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appIconCenterYAlignmentConstraint.constant = -150
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            }, completion: { (bool) in
                UIView.animate(withDuration: 0.5, animations: {
                    self.fbLoginButton.tintColor = UIColor.white
                })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func FBloginButtonpressed(_ sender: UIButton) {
        // GET FB CREDETIALS
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_friends"], from: self, handler: {
            (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if (result?.isCancelled)! {
                print("Cancelled")
                return
            } else {
                print("Logged in")
                // USE FB CREDETIALS TO LOGIN TO FIR
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                
                    FIRAuth.auth()?.signIn(with: credential) { (userToLogIn, error) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    } else {
                        user = userToLogIn
                       
                        FBSDKGraphRequest.init(graphPath: "me?fields=first_name,last_name,picture.width(640),gender", parameters: nil).start(completionHandler: {
                        (connection, result, error) in
                            if let error = error {
                            print(error.localizedDescription)
                            } else {
                            print(result)
                                let profileImageURL = (((result as! NSDictionary)["picture"]as! NSDictionary)["data"]as! NSDictionary)["url"] as! String
                                dataBaseRef.child("users").child(user!.uid).setValue([
                                    "username" : user!.displayName!,
                                    "email" : user!.email!,
                                    "firstname": (result as! NSDictionary)["first_name"]!,
                                    "lastname": (result as! NSDictionary)["last_name"]!,
                                    "profileSmallImageURL": user!.photoURL!.absoluteString,
                                    "profileImageURL": profileImageURL,
                                    "gender" : (result as! NSDictionary)["gender"]!,
                                    ])
                                self.presentingViewController?.dismiss(animated: true, completion: nil)
                            }
                            
                        })
                        

    

                    }
                }
            }
        })
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
