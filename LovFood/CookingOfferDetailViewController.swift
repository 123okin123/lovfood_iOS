//
//  CookingOfferDetailViewController.swift
//  LovFood
//
//  Created by Nikolai Kratz on 20.05.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
import MapKit
import AVKit
import AVFoundation

class CookingOfferDetailViewController: UITableViewController {

    var cookingEvent :CookingEvent?
    
    
    var player :AVPlayer!

    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var mapRadiusView: UIView! {
        didSet {
        mapRadiusView.layer.cornerRadius = 50
        }
    }
    @IBOutlet weak var sendButton: UIButton!  { didSet {
        sendButton.layer.cornerRadius = 3
        }
    }
    @IBOutlet weak var cookingOfferDetailImageView: UIImageView!
    @IBOutlet weak var profileDetailImageView: UIImageView! {didSet {
        profileDetailImageView.layer.cornerRadius = self.profileDetailImageView.frame.size.width / 2
        profileDetailImageView.clipsToBounds = true
        profileDetailImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profileDetailImageView.layer.borderWidth = 3
        }}
    @IBOutlet weak var cookingOfferTitleLabel: UILabel!
    @IBOutlet weak var cookingOfferDescriptionLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileTextLable: UILabel!
    @IBOutlet weak var candleLightDinnerIndicator: UIImageView!
    @IBOutlet weak var priceLable: UILabel!
    @IBOutlet weak var priceLabelDescription: UILabel!
    
   
    @IBOutlet weak var cookingTogetherView: UIView!
    @IBOutlet weak var candleLightView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func sendButtonPressed(sender: UIButton) {
        messageTextField.text = ""
        messageTextField.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240
        
        

        if cookingEvent!.usesVideo {
        let playerController = AVPlayerViewController()
        addChildViewController(playerController)
        playerController.view.frame = cookingOfferDetailImageView.frame
        cookingOfferDetailImageView.addSubview(playerController.view)
        playerController.didMoveToParentViewController(self)
        playerController.showsPlaybackControls = false
        playerController.videoGravity = AVLayerVideoGravityResizeAspectFill

        let path = NSBundle.mainBundle().pathForResource("tasty1", ofType:"mov")
        player = AVPlayer(URL: NSURL(fileURLWithPath: path!))
        player.muted = true
        playerController.player = player
        player.play()
    
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(CookingOfferDetailViewController.playerItemDidReachEnd),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: self.player.currentItem)
        }
    }

    
    func playerItemDidReachEnd() {
    self.player.play()
    }
    
    
    
    func loadData() {
        cookingOfferDetailImageView.image = cookingEvent!.cookingOfferImage
        profileDetailImageView.image = cookingEvent!.profile?.profileImage
        cookingOfferTitleLabel.text = cookingEvent!.title
        cookingOfferDescriptionLabel.text = cookingEvent!.description
        profileName.text = cookingEvent!.profile?.firstName
        
        self.title = cookingEvent!.title
        
        switch cookingEvent!.occasion {
        case .CandleLightDinner?:
            candleLightDinnerIndicator.highlighted = true
            candleLightView.hidden = false
            cookingTogetherView.hidden = true
        case .CookingTogether?:
            candleLightDinnerIndicator.highlighted = false
            candleLightView.hidden = true
            cookingTogetherView.hidden = false
        case .CommercialDining?: break
        case nil: break
        }
        
        if cookingEvent?.price != nil {
        priceLable.text = "\(cookingEvent!.price!) €"
        } else {
        priceLable.hidden = true
        priceLabelDescription.hidden = true
        }

    
        profileTextLable.text = cookingEvent?.profile?.profileText
        if cookingEvent?.coordinates != nil {
        let region = MKCoordinateRegion(center: cookingEvent!.coordinates!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
       
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        messageTextField.resignFirstResponder()
        if tableView.contentOffset.y < 0 {
            cookingOfferDetailImageView.frame.size.height = 180 - tableView.contentOffset.y
            cookingOfferDetailImageView.frame.origin.y = tableView.contentOffset.y
        } else {
            cookingOfferDetailImageView.frame.size.height = 180
            cookingOfferDetailImageView.frame.origin.y = 0

        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
  
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            switch section {
            
            case 2:
                return "Who will come?"
            case 3:
                return "Info"
            case 4:
                return "Who hosts me?"
            case 5:
                return "Where is it?"
            default:
                return nil
            }
    
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
