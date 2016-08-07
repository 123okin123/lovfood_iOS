//
//  CreateEventViewController.swift
//  LovFood
//
//  Created by Nikolai Kratz on 29.05.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit

class CreateEventViewController: UITableViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {


    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var titleTextView: UITextField!
    @IBOutlet weak var attendeesCountLabel: UILabel!
    @IBOutlet weak var imageScrollView: UIScrollView!
    

  
    let imagePicker = UIImagePickerController()
    var images = [UIImage]()
    var imageViewFrameOriginX :CGFloat = screenwidth
    let ownImageView = UIImageView()
    
    var cookingEvent = CookingEvent()
    var date = NSDate()
    
    


    
    @IBAction func datePickerValueChanged(sender: UIDatePicker) {
     date = sender.date
    }

    


    
    @IBAction func specialButtonPressed(sender: FilterButton) {
        if !sender.selected {
            sender.selected = true
        } else {
            sender.selected = false
        }
    }
    
    @IBAction func candleLightSwitchPressed(sender: UISwitch) {
        let cell =  tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 1))! as UITableViewCell
        if sender.on { cell.hidden = true} else {cell.hidden = false}
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
        imageScrollView.delegate = self
      

      
        
        tableView.delegate = self
        tableView.dataSource = self
        descriptionTextView.delegate = self
        titleTextView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 240
        descriptionTextView.text = "Describe what you want to cook"
        descriptionTextView.textColor = UIColor(red: 206/255, green: 206/255, blue: 211/255, alpha: 1.0)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        descriptionTextView.resignFirstResponder()
        titleTextView.resignFirstResponder()
        cookingEvent.description = descriptionTextView.text
        cookingEvent.title = titleTextView.text
    }
    
    
    
    
    
    
    func textViewDidBeginEditing(textView: UITextView) {
        if descriptionTextView.textColor == UIColor(red: 206/255, green: 206/255, blue: 211/255, alpha: 1.0) {
            descriptionTextView.text = ""
            descriptionTextView.textColor = UIColor.blackColor()
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Describe what you want to cook"
            descriptionTextView.textColor = UIColor(red: 206/255, green: 206/255, blue: 211/255, alpha: 1.0)
        }
    }


    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        descriptionTextView.resignFirstResponder()
        titleTextView.resignFirstResponder()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

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
