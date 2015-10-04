//
//  UIViewController+VBViewController.swift
//  Viral-Bible-Ios
//
//  Created by Philip Loden on 10/4/15.
//  Copyright © 2015 Alan Young. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func VB_instantiateFromStoryboard() -> UIViewController {
        let className = NSStringFromClass(self).componentsSeparatedByString(".").last!
        
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(className)
    }
    
}
