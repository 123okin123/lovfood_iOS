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
        fbLoginButton.layer.borderColor = UIColor.whiteColor().CGColor
        fbLoginButton.layer.borderWidth = 1
        fbLoginButton.layer.cornerRadius = 5
        fbLoginButton.tintColor = UIColor.clearColor()
        }}
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        appIconCenterYAlignmentConstraint.constant = -150
        UIView.animateWithDuration(0.5, animations: {
            self.view.layoutIfNeeded()
            }, completion: { (bool) in
                UIView.animateWithDuration(0.5, animations: {
                    self.fbLoginButton.tintColor = UIColor.whiteColor()
                })
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func FBloginButtonpressed(sender: UIButton) {
        // GET FB CREDETIALS
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        loginManager.logInWithReadPermissions(["public_profile", "email", "user_friends"], fromViewController: self, handler: {
            (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else if (result.isCancelled) {
                print("Cancelled")
                return
            } else {
                print("Logged in")
                // USE FB CREDETIALS TO LOGIN TO FIR
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                
                
                    FIRAuth.auth()?.signInWithCredential(credential) { (userToLogIn, error) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    } else {
                        user = userToLogIn
                       
                        FBSDKGraphRequest.init(graphPath: "me?fields=first_name,last_name,picture.width(640),gender", parameters: nil).startWithCompletionHandler({
                        (connection, result, error) in
                            if let error = error {
                            print(error.localizedDescription)
                            } else {
                            print(result)

                                dataBaseRef.child("users").child(user!.uid).setValue([
                                    "username" : user!.displayName!,
                                    "email" : user!.email!,
                                    "firstname": (result as! NSDictionary)["first_name"]!,
                                    "lastname": (result as! NSDictionary)["last_name"]!,
                                    "profileSmallImageURL": user!.photoURL!.absoluteString,
                                    "profileImageURL": (result as! NSDictionary)["picture"]!["data"]!!["url"]! as! String,
                                    "gender" : (result as! NSDictionary)["gender"]!,
                                    ])
                                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
