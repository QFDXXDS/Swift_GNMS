//
//  GNExtension.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/10/12.
//  Copyright © 2018 XXDS. All rights reserved.
//

import Foundation


extension URL {
    
   static func  genaralURL(urlStr: String ) -> URL {
    
    
    print("genaralURL " + urlStr)
        if urlStr.hasPrefix("http") {
            
            return URL.init(string: urlStr)!
        } else {
            
            return URL.init(fileURLWithPath: urlStr)

        }
    }

}
