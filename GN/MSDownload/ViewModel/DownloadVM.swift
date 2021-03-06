//
//  DownloadService.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/12.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit
//import Realm
import ReactiveCocoa
import ReactiveSwift
import Result

class DownloadVM: NSObject {

    var tableArray = [PlayerModel]()
    var lyricArray = [Substring]()
        
    func downloadLyric(model: PlayerModel) ->  Signal<Any, NoError>  {
        
        let (signal,ob) = Signal<Any, NoError>.pipe()
        
        _ = lyricReq.init(link:model.lrcLink! , name: model.songName! , songId: model.songId!   )
        
//        GN.HTTPDownload(req: req) { (rsp, err) in
//
//            do {
//
//                let dataStr = try String.init(contentsOf: URL.init(fileURLWithPath: req.downloadFile()))
//
//                if dataStr.contains("\r\n") {
//
//                    self.lyricArray = dataStr.split(separator: "\r\n")
//                } else {
//
//                    self.lyricArray = dataStr.split(separator: "\n")
//
//                }
//                ob.sendCompleted()
//
//            }
//
//            catch {
//
//
//            }
//
//        }
        
        return signal
    }

    
    
    func  downloadList() ->  Signal<Any, NoError> {
    
        let (signal,ob) = Signal<Any, NoError>.pipe()
        
        QueueScheduler.init(qos: .background, name: "123132", targeting: nil).schedule {
            
            DownloadDAO.fetchData(songId: nil){ temp in
                
                self.tableArray = temp
                UIScheduler.init().schedule({
                    ob.sendCompleted()
                })
                
            }
        }
        return signal
    }
}
