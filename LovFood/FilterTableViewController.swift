//
//  FilterTableViewController.swift
//  LovFood
//
//  Created by Nikolai Kratz on 24.04.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {

  
    

    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!

    @IBOutlet weak var candlelightdinnerButton: FilterButton!
    
    @IBOutlet weak var cookingtogetherButton: FilterButton!
    
    
    @IBAction func filterButtonPressed(sender: UIButton) {
        switch sender.tag {

        case 0:
            if !sender.selected {
                filter.gender = .Female
                sender.selected = true
                maleButton.selected = false
            } else {
                filter.gender = .None
                sender.selected = false
            }
        case 1:
            if !sender.selected {
                filter.gender = .Male
                sender.selected = true
                femaleButton.selected = false
            } else {
                filter.gender = .None
                sender.selected = false
            }
        case 2:
            if !sender.selected {
                filter.cookingOccasion = .CandleLightDinner
                sender.selected = true
                cookingtogetherButton.selected = false
            } else {
                filter.cookingOccasion = nil
                sender.selected = false
            }
        case 3:
            if !sender.selected {
                filter.cookingOccasion = .CookingTogether
                sender.selected = true
                candlelightdinnerButton.selected = false
            } else {
                filter.cookingOccasion = nil
                sender.selected = false
            }

        default:
            if !sender.selected {
                sender.selected = true
            } else {
                sender.selected = false
            }

        }
        for i in 0...cookingEventsArrays.count - 1 {
            cookingEventsArrays[i].removeAll()
        }

    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      print(filter.gender)
        
        if filter.gender == .Female {
            femaleButton.selected = true
        }
        if filter.gender == .Male {
            maleButton.selected = true
        }
        
        if filter.cookingOccasion != nil {
            if filter.cookingOccasion! == .CandleLightDinner {
                candlelightdinnerButton.selected = true
            }
            if filter.cookingOccasion! == .CookingTogether {
                cookingtogetherButton.selected = true
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print(filter.gender)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
