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
    
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        switch sender.tag {

        case 0:
            if !sender.isSelected {
                filter.gender = .Female
                sender.isSelected = true
                maleButton.isSelected = false
            } else {
                filter.gender = .None
                sender.isSelected = false
            }
        case 1:
            if !sender.isSelected {
                filter.gender = .Male
                sender.isSelected = true
                femaleButton.isSelected = false
            } else {
                filter.gender = .None
                sender.isSelected = false
            }
        case 2:
            if !sender.isSelected {
                filter.cookingOccasion = .CandleLightDinner
                sender.isSelected = true
                cookingtogetherButton.isSelected = false
            } else {
                filter.cookingOccasion = nil
                sender.isSelected = false
            }
        case 3:
            if !sender.isSelected {
                filter.cookingOccasion = .CookingTogether
                sender.isSelected = true
                candlelightdinnerButton.isSelected = false
            } else {
                filter.cookingOccasion = nil
                sender.isSelected = false
            }

        default:
            if !sender.isSelected {
                sender.isSelected = true
            } else {
                sender.isSelected = false
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
            femaleButton.isSelected = true
        }
        if filter.gender == .Male {
            maleButton.isSelected = true
        }
        
        if filter.cookingOccasion != nil {
            if filter.cookingOccasion! == .CandleLightDinner {
                candlelightdinnerButton.isSelected = true
            }
            if filter.cookingOccasion! == .CookingTogether {
                cookingtogetherButton.isSelected = true
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(filter.gender)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
