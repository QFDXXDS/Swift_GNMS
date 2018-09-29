//
//  DownloadReq.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/12.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit

class DownloadReq: GNHTTPReq {

    
    let link: String
    let name: String
    let songId: Int
    let age = "dslcs"

    init(link: String, name: String, songId: Int) {
        
        self.link = link
        self.songId = songId
        self.name = name
    }
}

class songReq: DownloadReq {
    
    override func URLStr() -> String {
        
        return  self.link
    }
    
    override func downloadFile() -> String {
        
        return  DownloadManager.ma.path + "/" + ("\(songId)" + ".mp3" )
    }

}

class lyricReq: DownloadReq {
    
    override func URLStr() -> String {
        
        return  self.link
    }

    override func downloadFile() -> String {
        
        return  DownloadManager.ma.path + "/" + ("\(songId)" + ".lyric" )
    }

}


