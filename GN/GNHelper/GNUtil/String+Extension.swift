//
//  String+Extension.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/9/27.
//  Copyright © 2018 XXDS. All rights reserved.
//

import Foundation

extension String {
    
    static func stringWithSeconds(seconds: Int) -> String {
        
        if seconds < 60 {
            
           return String.init(format: "00:%02d", seconds)
        } else if seconds < 3600 && seconds > 60 {
            
            let min = seconds/60;
            let second = seconds%60;
            return String.init(format: "%02d:%02d", min,second)

        } else {
            
            let hour = seconds/3600;
            let count = seconds%3600;
            let min = count/60;
            let second = count%60;
            return String.init(format: "%02d:%02d:%02d",hour, min,second)
        }
        
    }
}

