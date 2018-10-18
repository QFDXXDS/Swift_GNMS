//
//  GNHTTPReq.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/2/27.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit
import Alamofire

@objcMembers class GNHTTPReq: NSObject, GNHTTPProtocol, GNHandyJSON {

    
    required override  init() {
//        super.init()
    }
    func parameters() -> Dictionary<String, Any> {
        
        return self.toJSON()!
    }
    
    func reqMethod() -> HTTPMethod {
        
        return .get
    }
    func URLStr() -> String {
        
        return  ""
    }
    func downloadFile() -> String {
        
        return ""
    }

}
