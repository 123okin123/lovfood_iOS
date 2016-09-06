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
        super.layoutSubviews()
        cellContentView.layer.cornerRadius = 5.0
        cellContentView.layer.masksToBounds = true

        
        layer.shadowColor = UIColor.grayColor().CGColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSizeZero
        layer.shadowRadius = 3
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cookingEventImageView?.image = nil
    }
    
}
