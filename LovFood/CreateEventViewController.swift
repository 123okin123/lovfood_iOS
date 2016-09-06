//
//  CreateEventViewController.swift
//  LovFood
//
//  Created by Nikolai Kratz on 29.05.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit

class CreateEventViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var focusViewDoneButton: UIButton!
    @IBOutlet var focusView: UIView!
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light))
    var cellRect = CGRect()
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var attendeesCountLabel: UILabel!
    @IBOutlet weak var profilePictureImageView: UIImageView! {didSet{
        profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2
        profilePictureImageView.clipsToBounds = true
        profilePictureImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profilePictureImageView.layer.borderWidth = 3
        if userCookingProfile != nil && user != nil {
            profilePictureImageView.image = userCookingProfile!.profileImage
        }
        }}
    
    var placeholderColor = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1)
    var cookingEvent = CookingEvent()


    @IBAction func focusViewDoneButtonPressed(sender: UIButton) {
        cookingEvent.description = descriptionTextView.text
        cookingEvent.title = titleTextField.text

        tableView.reloadData()
        if cookingEvent.title == "" {
        titleLabel.text = "Please give your Event a Title"
        titleLabel.textColor = lovFoodColor
        } else {
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.text = cookingEvent.title
        }
        if cookingEvent.description == "" {
            descriptionLabel.text = "Please write something about you or what you want to cook."
            descriptionLabel.textColor = lovFoodColor
        } else {
            descriptionLabel.textColor = UIColor.blackColor()
            descriptionLabel.text = cookingEvent.description
        }
        
        
        UIView.animateWithDuration(0.3, animations: {
            self.descriptionTextView.alpha = 0
            self.titleTextField.alpha = 0
            self.focusViewDoneButton.alpha = 0
            }, completion: {done in
                UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
                    self.focusView.frame = self.cellRect
                    self.focusView.layer.cornerRadius = 0
                    self.visualEffectView.alpha = 0
                    self.focusView.layoutSubviews()
                    }, completion: {done in
                        self.visualEffectView.removeFromSuperview()
                        self.focusView.removeFromSuperview()
                        
                })
        })

        


        
    }
    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
     cookingEvent.eventDate = sender.date
    }

    
    
    @IBAction func candleLightSwitchPressed(sender: UISwitch) {
        let cell =  tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))! as UITableViewCell
        if sender.on {
            cell.hidden = true
            cookingEvent.occasion = .CandleLightDinner
        } else {
            cell.hidden = false
            cookingEvent.occasion = .CookingTogether
        }
    }
    

    @IBAction func plusButtonPressed(sender: PlusMinusButton) {
        var count = Int(attendeesCountLabel.text!)!
        if count < 20 {
        count += 1
        attendeesCountLabel.text = String(count)
        }
    }
    @IBAction func minusButtonPressed(sender: PlusMinusButton) {
        var count = Int(attendeesCountLabel.text!)!
        if count > 0 {
        count -= 1
        attendeesCountLabel.text = String(count)
        }
    }
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        tableView.delegate = self
        tableView.dataSource = self
        descriptionTextView.delegate = self
        descriptionTextView.text = "Your Description"
        descriptionTextView.textColor = placeholderColor
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240

        
        
        //Some default data
        cookingEvent.occasion = .CookingTogether
        cookingEvent.eventDate = datePicker.date
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
 


    }
    
 

    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
        
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
        showFocusViewForIndexPath(indexPath)
        }
    }
    
    
    
    func showFocusViewForIndexPath(indexPath: NSIndexPath) {
        visualEffectView.frame = self.navigationController!.view.bounds
        visualEffectView.alpha = 0
        self.navigationController!.view.addSubview(visualEffectView)
    
        
        cellRect = tableView.rectForRowAtIndexPath(indexPath)
        cellRect = CGRectOffset(cellRect, -tableView.contentOffset.x, -tableView.contentOffset.y)
        cellRect.size.width -= 20
        cellRect.origin.x += 10
        cellRect.origin.y += 64
        focusView.frame = cellRect
        focusView.layer.cornerRadius = 10
        focusView.backgroundColor = UIColor.whiteColor()
        focusView.layer.shadowColor = UIColor.grayColor().CGColor
        focusView.layer.shadowOpacity = 0.5
        focusView.layer.shadowOffset = CGSizeZero
        focusView.layer.shadowRadius = 1
        
        self.navigationController!.view.addSubview(focusView)
        titleTextField.alpha = 0
        descriptionTextView.alpha = 0
        focusViewDoneButton.alpha = 0
        
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: {
            self.visualEffectView.alpha = 1
            self.focusView.frame.size.height = screenheight - 280
            self.focusView.frame.origin.y = 50
            
            }, completion: {done in
                UIView.animateWithDuration(0.3, animations: {
                    self.titleTextField.alpha = 1
                    self.focusViewDoneButton.alpha = 1
                    self.descriptionTextView.alpha = 1
                })
        })
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if descriptionTextView.textColor == placeholderColor {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.blackColor()
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Your Description"
            descriptionTextView.textColor = placeholderColor
        }
    }
    
    @IBAction func backFromSelectImageSegue(segue: UIStoryboardSegue) {
    let selectImageVC = segue.sourceViewController as! SelectImageViewController
        if let imageObject = selectImageVC.selectedImage  {
            
            if let imageID = imageObject.imageID {
            storageRef.child("eventImages/full/\(imageID)").dataWithMaxSize(2 * 1024 * 1024) { (data, error) -> Void in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print(error)
                } else {
                    let image: UIImage! = UIImage(data: data!)
                    self.imageView.image = image
                    
                }
            }
            }
            if let fullURL = imageObject.fullURL {
            cookingEvent.imageURL = NSURL(string: fullURL)
            }
            

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
