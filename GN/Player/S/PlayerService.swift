//
//  PlayerService.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/6.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit

class PlayerService: NSObject {

    
    class func  getSong(singID:String, success: @escaping GNHTTPSuccessCloser, fail: @escaping GNHTTPErrorCloser ) {
        
        let req = PlayerReq()
        req.songIds = singID
        
        
        
        GN.HTTPRequesgt(req: req) { (rsp, err) in
            
             (err != nil) ? fail(err as! Error) : success(rsp as Any)
        }
    }

}


