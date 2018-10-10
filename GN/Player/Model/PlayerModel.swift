//
//  PlayerModel.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/6.
//  Copyright © 2018年 XXDS. All rights reserved.
//


struct PlayerModel: GNHandyJSON {
    
    var songId : Int?
    var songName : Any?
    var artistName :  Any?
    var songPicBig : Any?
    var songLink : Any?
    var lrcLink : Any?
    var time : Any?
    var CurrentTime : Any?

    
    static  func wrraperData(object: Any) -> PlayerModel  {
        
        print(" PlayerModel is  \(object)")
        let dic = object as? Dictionary<String, Any>
        let dic1: Dictionary<String, Any> = dic!["data"] as! Dictionary<String, Any>
        let array:Array<Any> = dic1["songList"] as! Array
        let dic2: Dictionary<String, Any> = array[0] as! Dictionary<String, Any>
        
        let model = PlayerModel.deserialize(from: dic2)
       
        return model!
    }

    
}


