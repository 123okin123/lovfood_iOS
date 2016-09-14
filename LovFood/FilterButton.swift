//
//  FilterButton.swift
//  LovFood
//
//  Created by Nikolai Kratz on 23.05.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit
@IBDesignable

class FilterButton: UIButton {

    
    var customImageView =  UIImageView()
    var label: UILabel?
    @IBInspectable var image: UIImage?
    @IBInspectable var selectedImage: UIImage?
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        customImageView.frame.origin = CGPoint(x: (self.bounds.size.width / 2) - 30, y: 0)
        customImageView.frame.size = CGSize(width: 60, height: 60)
        customImageView.image = image
        self.addSubview(customImageView)
        
        if self.isSelected {
        customImageView.image = selectedImage
        }
    }


    

}
