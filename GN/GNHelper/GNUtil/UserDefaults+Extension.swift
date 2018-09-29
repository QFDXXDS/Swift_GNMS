//
//  UserDefaults+Extension.swift
//  GN
//
//  Created by Xianxiangdaishu on 2017/10/30.
//  Copyright © 2017年 XXDS. All rights reserved.
//

import Foundation

extension UserDefaults {

    class  func setObject( value: Any?,  key: String) {
        
        let def = UserDefaults.standard;
        def.set(value, forKey: key) ;
    }
    class func getValue(forKey key:String) -> Any? {
        
        let def = UserDefaults.standard;
        let value:Any? = def.object(forKey: key) ;
        return value ;
    }
    
}
