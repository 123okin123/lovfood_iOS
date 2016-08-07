//
//  PlusMinusButton.swift
//  LovFood
//
//  Created by Nikolai Kratz on 31.05.16.
//  Copyright © 2016 Nikolai Kratz. All rights reserved.
//

import UIKit

@IBDesignable

class PlusMinusButton: UIButton {
    
    @IBInspectable var isPlusButton :Bool = false
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let backgroundpath = UIBezierPath(ovalInRect: self.bounds)
        UIColor(red: 233/255, green: 106/255, blue: 103/255, alpha: 1.0).setFill()
        backgroundpath.fill()
        
        let minuspath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: 5, y: self.bounds.size.height / 2 - 1), size: CGSize(width: 20, height: 2)), cornerRadius: 2)
        UIColor.whiteColor().setFill()
        minuspath.fill()
        
        if isPlusButton {
        let pluspath = UIBezierPath(roundedRect: CGRect(origin: CGPoint(x: self.bounds.size.width / 2 - 1, y: 5), size: CGSize(width: 2, height: 20)), cornerRadius: 2)
        UIColor.whiteColor().setFill()
        pluspath.fill()
        }
    }
    

}
