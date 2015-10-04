//
//  Helper.swift
//  Viral-Bible-Ios
//
//  Created by Philip Loden on 10/4/15.
//  Copyright © 2015 Alan Young. All rights reserved.
//

import Foundation

class Helper : NSObject {
    
    class func S3SecretKey() -> String? {
        let info = NSBundle.mainBundle().infoDictionary
        return info?["S3_SECRET_KEY"] as? String
    }
    
    class func S3AccessKeyID() -> String? {
        let info = NSBundle.mainBundle().infoDictionary
        return info?["S3_ACCESS_KEY_ID"] as? String
    }
    
    class func S3Bucket() -> String? {
        let info = NSBundle.mainBundle().infoDictionary
        return info?["S3_BUCKET"] as? String
    }
    
}