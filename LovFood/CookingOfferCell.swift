//
//  CookingOfferCell.swift
//  LovFood
//
//  Created by Nikolai Kratz on 24.04.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit

class CookingOfferCell: UICollectionViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var cookingOfferTitle: UILabel!
    @IBOutlet weak var cookingOfferImageView: UIImageView!
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var candelLightDinnerIndicator: UIImageView!
    @IBOutlet weak var cookingOfferDistance: UILabel!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cookingOfferImageView?.image = nil
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.borderColor = UIColor.whiteColor().CGColor
        profileImage.layer.borderWidth = 3
        
        
        cellContentView.layer.cornerRadius = 8
        
        cookingOfferTitle.layer.shadowColor = UIColor.blackColor().CGColor
        cookingOfferTitle.layer.shadowOffset = CGSize(width: 1, height: 1)
        cookingOfferTitle.layer.shadowOpacity = 0.5
        cookingOfferTitle.layer.shadowRadius = 1
        cookingOfferTitle.layer.masksToBounds = false
        
        cookingOfferDistance.layer.shadowColor = UIColor.blackColor().CGColor
        cookingOfferDistance.layer.shadowOffset = CGSize(width: 1, height: 1)
        cookingOfferDistance.layer.shadowOpacity = 0.5
        cookingOfferDistance.layer.shadowRadius = 1
        cookingOfferDistance.layer.masksToBounds = false
        

    
    }
    
    
}
