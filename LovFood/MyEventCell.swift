//
//  MyEventCell.swift
//  LovFood
//
//  Created by Nikolai Kratz on 26.07.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit

class MyEventCell: UICollectionViewCell {
    @IBOutlet weak var cookingEventImageView: UIImageView!
    @IBOutlet weak var cookingEventDateLabel: UILabel!
    @IBOutlet weak var cookingEventTitleLabel: UILabel!
    @IBOutlet weak var cookingEventAttendeesCountLabel: UILabel!
    
    @IBOutlet weak var cellContentView: UIView!
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        
    }
}
