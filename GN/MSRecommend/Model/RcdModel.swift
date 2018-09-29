//
//  MSRecommendModel.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/2.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit

struct  RcdModel: Equatable {
    
    
    static func ==(lhs: RcdModel, rhs: RcdModel) -> Bool {
        
       return lhs.song_id as? String == rhs.song_id as? String
    }
    

    var title : Any?
    var song_id : Any?
    var artist_name : Any?
    var pic_big : Any?
    var hot : Any?
    var file_duration : Any?

    
    static  func wrraperData(object: Dictionary<String,Any>) -> Array<Any> {
        
        let arr :Array<Any> = object["song_list"] as! Array
        
        var temp = [Any]()
            for dic in arr {
                
                let dic1 = dic as! Dictionary<String, Any>
                
                var model = RcdModel()
                
                
                model.title = dic1["title"]
                model.song_id = dic1["song_id"]
                model.artist_name = dic1["artist_name"]
                model.pic_big = dic1["pic_big"]
                model.hot = dic1["hot"]
                model.file_duration = dic1["file_duration"]
                temp.append(model)
            }
        return temp
        }
}



struct RcdScrollModel {
    
    var title : Any?
    var song_id : Any?
    var artist_name : Any?
    var pic_big : Any?
    var hot : Any?
    var file_duration : Any?
    
    
    
    
    static  func wrraperData(object: Dictionary<String,Any>) -> Array<Any> {

        let arr :Array<Any> = object["song_list"] as! Array
        
        var temp = [Any]()
        for dic in arr {
            
            let dic1 = dic as! Dictionary<String, Any>
            
            var model = RcdScrollModel()
            
            
            model.title = dic1["title"]
            model.song_id = dic1["song_id"]
            model.artist_name = dic1["artist_name"]
            model.pic_big = dic1["pic_big"]
            model.hot = dic1["hot"]
            model.file_duration = dic1["file_duration"]
            temp.append(model)
        }
        return temp
    }
    
}

