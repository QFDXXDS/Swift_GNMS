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
    var progressValue = MutableProperty("")
    var downloadHide = MutableProperty(false)

    
    func isDownload()  {
      
        let songId = PlayerManager.ma.vm.model.value.songId
        if songId != nil {
            
            isEable.value = !DownloadDAO.isExist(songId:songId!)
        }
    }
    
    func download(model: PlayerModel)   {
        
        progressHide.value = false
        downloadHide.value = true
        
        let req = songReq.init(link:model.songLink!, name: model.songName!, songId: model.songId!  )
        let sig = GN.HTTPDownload(req: req)
        
        sig.observeCompleted {
            
            self.progressHide.value = true
            self.downloadHide.value = false
            self.isEable.value = false
            DownloadDAO.insertModel(model: model)
        }
        sig.observeValues { (s) in
            
            self.progressValue.value = s as! String
        }
    }

}

