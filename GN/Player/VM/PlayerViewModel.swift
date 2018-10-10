//
//  PlayerService.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/6.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit

class PlayerVM: NSObject {

    var model = MutableProperty(PlayerModel.init())
     func  getSong(singID:String ) -> GNSignal<Any,GNNoError> {
        
        let req = PlayerReq()
        req.songIds = singID
        
        let (signal,ob) = GNSignal<Any, GNNoError>.pipe()

        GN.HTTPRequesgt(req: req).observeValues { (rsp) in
            
            self.model.value = PlayerModel.wrraperData(object: rsp)
            ob.sendCompleted()
        }
        
        return signal
    }
    
    

}


