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

    var tableArray = Array<Any>()
    var collectionArray = Array<Any>()


    func getRecommendList(page: Int, size: Int) -> SignalProducer<Any, NoError>  {
        
        let req = RcdListReq()
        req.type = 2
        req.page = page
        req.size = size
        
        
        let producer = SignalProducer<Any, NoError>.init { (ob, _) in
            
            GN.HTTPRequesgt(req: req) { (rsp, err) in
                
                if rsp is Dictionary<String, Any> {
                    
                    self.tableArray = RcdModel.wrraperData(object: rsp as! Dictionary<String, Any>)
                }
                print("RecommendList is \(String(describing: rsp))")
                ob.sendCompleted()
            }
        };
        
        return producer
    }
    func getRecommendScrollList() -> SignalProducer<Any, NoError>  {
        
        let req = RcdListScrollReq()
        req.type = 1
        
        let producer = SignalProducer<Any, NoError>.init { (ob, _) in

            GN.HTTPRequesgt(req: req) { (rsp, err) in
                
                if rsp is Dictionary<String,Any> {
                    
                    self.collectionArray = RcdScrollModel.wrraperData(object: rsp as! Dictionary<String, Any>)
                }
                ob.sendCompleted()
            }
        }
        
        return producer
    }
}
