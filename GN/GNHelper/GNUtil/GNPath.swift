//
//  GNPath.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/12.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit

class GNPath: NSObject {

    @discardableResult
    class func path() -> String  {
        
        let path = self.cachePath() + "/music"
        
        let ma = FileManager.default
        if !ma.isExecutableFile(atPath: path) {
            
            try? ma.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            
        }
        return path
    }
    
    class func cachePath() -> String {
        
        let path = NSSearchPathForDirectoriesInDomains(.cachesDirectory,  .userDomainMask, true).first
        
        print("cachePath is \(String(describing: path))")
        return path!

    }
    
    class func docuemntPath() -> String  {
    
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory,  .userDomainMask, true).first
        
        print("docuemntPath is \(String(describing: path))")
        return path!

    }
//    class func songPath() -> String  {
//
//        self.cachePath()
//
//        print("docuemntPath is \(String(describing: path))")
//        return path!
//    }
//
    
    
}

