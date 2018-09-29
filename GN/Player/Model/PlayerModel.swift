//
//  PlayerModel.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/6.
//  Copyright © 2018年 XXDS. All rights reserved.
//


struct PlayerModel {
    
    var songId : Int?
    var songName : Any?
    var artistName :  Any?
    var songPicBig : Any?
    var songLink : Any?
    var lrcLink : Any?
    var time : Any?
    var CurrentTime : Any?

    
    static  func wrraperData(object: Any) -> PlayerModel  {
        
        let dic = object as? Dictionary<String, Any>
        let dic1: Dictionary<String, Any> = dic!["data"] as! Dictionary<String, Any>
        let array:Array<Any> = dic1["songList"] as! Array
        let dic2: Dictionary<String, Any> = array[0] as! Dictionary<String, Any>
        
        let model = PlayerModel.init(songId: dic2["songId"] as! Int , songName: dic2["songName"], artistName: dic2["artistName"], songPicBig: dic2["songPicBig"], songLink: dic2["songLink"], lrcLink: dic2["lrcLink"], time: dic2["time"], CurrentTime: dic2["CurrentTime"])
        
        return model
    }

    
}


