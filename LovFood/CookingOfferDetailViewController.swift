//
//  CookingOfferDetailViewController.swift
//  LovFood
//
//  Created by Nikolai Kratz on 20.05.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import MapKit
import youtube_ios_player_helper

class CookingOfferDetailViewController: UITableViewController {

    var cookingEvent :CookingEvent?
   
    @IBOutlet weak var ytplayerView: YTPlayerView!
    @IBOutlet weak var ytplayerCell: UITableViewCell!
  

    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var mapRadiusView: UIView! {
        didSet {
        mapRadiusView.layer.cornerRadius = 50
        }
    }
    @IBOutlet weak var sendButton: UIButton!  { didSet {
        sendButton.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var cookingEventImageView: UIImageView!
    
    @IBOutlet weak var profileImageView: UIImageView! {didSet {
        profileImageView.layer.cornerRadius = 75
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.borderWidth = 3
        }}
 
    @IBOutlet weak var cookingOfferTitleLabel: UILabel!
    @IBOutlet weak var cookingOfferDescriptionLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileTextLable: UILabel!
    @IBOutlet weak var candleLightDinnerIndicator: UIImageView!

    @IBOutlet weak var profileFullNameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
   
    @IBOutlet weak var cookingTogetherView: UIView!
    @IBOutlet weak var candleLightView: UIView!
    @IBOutlet weak var canleLightLabel: UILabel!
    

    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {

        let today = Date()
        print(today)
        let dateFormatter = DateFormatter()
 
        print(dateFormatter.string(from: today))
        
        let conversationDictionary :NSDictionary = [
            "lastMessage" : self.messageTextField.text!,
            "lastMessageDate" : dateFormatter.string(from: today),
            "users" : [
                user.uid : true,
                self.cookingEvent!.userId! : true,
            ]
        ]
        let messageDictionary :NSDictionary = [
            "date" : dateFormatter.string(from: today),
            "senderId" : user.uid,
            "text" : self.messageTextField.text!
        ]
        
        let query = dataBaseRef.child("conversations").queryOrdered(byChild: "users/\(user.uid)").queryEqual(toValue: true)
        query.observeSingleEvent(of: .value, with: {(snapshot) in
            print(((snapshot.value as? NSDictionary)?.allValues as? [NSDictionary]))
            var conversationExists = false
            
            if let conversations = snapshot.value as? NSDictionary {
                for conversation in conversations {
                    if ((conversation.value as! NSDictionary)["users"] as! NSDictionary).isEqual(to: [self.cookingEvent!.userId! : 1, user.uid : 1]) {
                        print("conversation exists with id:\(conversation.key)")
                        dataBaseRef.child("conversations").child(conversation.key as! String).setValue(conversationDictionary)
                        dataBaseRef.child("messages").child(conversation.key as! String).childByAutoId().setValue(messageDictionary)
                        conversationExists = true
                    } else {
                        print("conversation does not exist")
                    }
                }
            }
            if !conversationExists {
                let conversationDBRef = dataBaseRef.child("conversations").childByAutoId()
                conversationDBRef.setValue(conversationDictionary)
                dataBaseRef.child("messages").child(conversationDBRef.key).childByAutoId().setValue(messageDictionary)
            }
        })
        messageTextField.text = ""
        messageTextField.resignFirstResponder()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240
        setupCookingEvent()

    }
    
    

    func setupCookingEvent() {
        cookingEventImageView.image = cookingEvent!.image
        profileImageView.image = cookingEvent!.profile?.profileImage
        cookingOfferTitleLabel.text = cookingEvent!.title
        cookingOfferDescriptionLabel.text = cookingEvent!.description
        profileName.text = cookingEvent!.profile?.firstName
        profileFullNameLabel.text = cookingEvent!.profile?.userName
        profileTextLable.text = cookingEvent?.profile?.profileText
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = .none
        timeFormatter.timeStyle = .short
        let today = Date()
        if let eventDate = cookingEvent!.eventDate {
            let dateString = dateFormatter.string(from: eventDate)
        switch dateString {
        case dateFormatter.string(from: today):
            dateLabel.text = "Today at " + timeFormatter.string(from: cookingEvent!.eventDate!)
        case dateFormatter.string(from: today.addingTimeInterval(60*60*24)):
            dateLabel.text = "Tomorrow at " + timeFormatter.string(from: cookingEvent!.eventDate!)
        default:
            dateLabel.text = dateFormatter.string(from: cookingEvent!.eventDate!) + " at " + timeFormatter.string(from: cookingEvent!.eventDate!)
        }
        }

        
        self.title = cookingEvent!.title
        
        switch cookingEvent!.occasion {
        case .CandleLightDinner?:
            candleLightDinnerIndicator.isHighlighted = true
            candleLightView.isHidden = false
            cookingTogetherView.isHidden = true
            canleLightLabel.text = "This is a candle-light dinner. It's just you and \(cookingEvent!.profile!.firstName!)."
        case .CookingTogether?:
            candleLightDinnerIndicator.isHighlighted = false
           candleLightView.isHidden = true
         cookingTogetherView.isHidden = false
        case .CommercialDining?: break
        case nil: break
        }
        
        
        if cookingEvent?.coordinates != nil {
            let region = MKCoordinateRegion(center: cookingEvent!.coordinates!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
            locationLabel.text = cookingEvent!.locationString
        }
        
        // if cookingEvent!.usesVideo {
        
        let playerVars = ["playsinline" : 1,
                          "controls" : 1,
                          "showinfo" : 0,
                          "modestbranding" : 0,
                          "loop" : 1,
                          "autoplay" : 1,
                          "playlist" : "mNHq7T9YHHs"
            ] as [String : Any]
        ytplayerView.load(withVideoId: "mNHq7T9YHHs", playerVars: playerVars)
        //        } else {
        //        ytplayerCell.isHidden = true
        //
        //        }
    }

    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
       
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        if tableView.contentOffset.y < 0 {
            cookingEventImageView.frame.size.height = 210 - tableView.contentOffset.y
            cookingEventImageView.frame.origin.y = tableView.contentOffset.y 
        } else {
            cookingEventImageView.frame.size.height = 210
            cookingEventImageView.frame.origin.y = 0

        }

        
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        messageTextField.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
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
