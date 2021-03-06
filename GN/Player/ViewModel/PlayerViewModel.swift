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
    var name = MutableProperty("")
    var history = MutableProperty([PlayerModel]())

    override init() {
    
        super.init()
        historyList()
        model.producer.startWithValues { [unowned self](newValue) in
            
            self.name.value = newValue.songName!
        }
    }
    
     func  getSong(songID:Int ) -> GNSignal<Any,GNNoError> {
        
        let (signal,ob) = GNSignal<Any, GNNoError>.pipe()

        DownloadDAO.fetchData(songId:songID) { (array) in
            
            if !array.isEmpty  {
                
                DispatchQueue.main.async {
                    let m = array[0]
                    
                    self.model.value = m
                    ob.sendCompleted()
                    
                }
                
            } else {
                
                let req = PlayerReq()
                req.songIds = songID
                GN.HTTPRequesgt(req: req).observeValues { (rsp) in
                    
                    self.model.value = PlayerModel.wrraperData(object: rsp)
                    ob.sendCompleted()
                }
            }
        }
        return signal
    }
    
    
    func historyList()  {
    
        HistoryDao.fetchData { (array) in
            if !array.isEmpty {
    
                self.history.value.append(contentsOf: array)
                self.model.value = array[0]
            }
        }
    }
    
}


