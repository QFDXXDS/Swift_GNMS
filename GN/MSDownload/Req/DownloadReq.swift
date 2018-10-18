//
//  DownloadReq.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/12.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit

class DownloadReq: GNHTTPReq {

    
    var link: String?
    var name: String?
    var songId: Int?

    convenience init(link: String, name: String, songId: Int) {
        
        self.init()

        self.link = link
        self.songId = songId
        self.name = name
        
    }
    
    required init() {

//        super.init()
    }
}

class songReq: DownloadReq {
    
    override func URLStr() -> String {
        
        return  self.link!
    }
    
    override func downloadFile() -> String {
        
        return  DownloadManager.ma.path + "/" + ("\(songId!)" + ".mp3" )
    }

}

class lyricReq: DownloadReq {
    
    override func URLStr() -> String {
        
        return  self.link!
    }

    override func downloadFile() -> String {
        
        return  DownloadManager.ma.path + "/" + ("\(songId)" + ".lyric" )
    }

}


