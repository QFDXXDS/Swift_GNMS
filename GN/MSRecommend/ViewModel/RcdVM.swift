//
//  MSRecommendService.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/2/27.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result



class  RcdVM {

    var tableArray = MutableProperty(Array<Any>())

    var collectionArray = Array<RcdScrollModel>()


    func getRecommendList(page: Int, size: Int) -> GNSignal<Any, GNNoError >  {
        
        let req = RcdListReq()
        req.type = 2
        req.page = page
        req.size = size
        
        let (signal,ob) = GNSignal<Any, GNNoError>.pipe()

        GN.HTTPRequesgt(req: req).observeValues { (rsp) in
            
            self.tableArray.value = RcdModel.wrraperData(object: rsp as! Dictionary<String, Any>)
            print("RecommendList is \(String(describing: rsp))")
            ob.sendCompleted()
        }
      
        return signal
    }
    func getRecommendScrollList() -> GNSignal<Any, GNNoError >   {
        
        let req = RcdListScrollReq()
        req.type = 1
        let (signal,ob) = GNSignal<Any, GNNoError>.pipe()

        GN.HTTPRequesgt(req: req).observeValues { (rsp) in
            
            self.collectionArray = RcdScrollModel.wrraperData(object: rsp as! Dictionary<String, Any>)
            let first = self.collectionArray.first as! RcdScrollModel
            let last = self.collectionArray.last as! RcdScrollModel

            self.collectionArray.append(first)
            self.collectionArray.insert(last, at: 0)
            ob.sendCompleted()
        }
        
        return signal
    }
    
    func selectModel(model: RcdModel)    {

        PlayerManager.playWithSongID(model.song_id!)

       
    }
}
