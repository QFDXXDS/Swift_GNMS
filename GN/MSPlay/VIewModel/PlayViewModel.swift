//
//  PlayViewModel.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/10/11.
//  Copyright © 2018 XXDS. All rights reserved.
//

import Foundation

class PlayViewModel {
    
    var isEable = MutableProperty(true)
    var progressHide = MutableProperty(true)

    func isDownload()  {
      
        let songId = PlayerManager.ma.vm.model.value.songId
        isEable.value = !DownloadDAO.isExist(songId:songId!)
    }
    
    func download(model: PlayerModel) ->  Signal<Any, NoError>  {
        
        progressHide.value = false
        let (signal,ob) = Signal<Any, NoError>.pipe()
        
        let req = songReq.init(link:model.songLink as! String, name: model.songName as! String, songId: model.songId!  )
        
        let sig = GN.HTTPDownload(req: req)
        sig.observeCompleted {
            
            self.progressHide.value = true
            self.isEable.value = false
            DownloadDAO.insertModel(model: model)
            ob.sendCompleted()
        }
        sig.observeValues { (s) in
            
            ob.send(value: s)
        }
        return signal
    }

}

