//
//  PlayerReq.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/6.
//  Copyright © 2018年 XXDS. All rights reserved.
//


class PlayerReq: GNHTTPReq {

    var songIds: Int?
    
    override func URLStr() -> String {
        
        return  MS_SONG_URL
    }

}
