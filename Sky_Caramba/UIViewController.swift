//
//  UIViewController.swift
//  Sky_Caramba
//
//  Created by Bartlomiej Siemieniuk on 05/12/2015.
//  Copyright © 2015 BSiemieniuk. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func setGradient() {
        
        let gradient = CAGradientLayer()
        
        let darkBlue  = UIColor(red: 16.0/255.0, green: 23.0/255.0, blue: 29.0/255.0, alpha: 1.0)

        let lightBlue = UIColor(red: 4.0/255.0, green: 47.0/255.0, blue: 85.0/255.0, alpha: 1.0)

        
        gradient.frame = view.bounds
        
        gradient.colors = [
            lightBlue.CGColor,
            darkBlue.CGColor
        ]
        
        view.layer.insertSublayer(gradient, atIndex: 0)
        
    }
}