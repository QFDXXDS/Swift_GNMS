//
//  DownloadManager.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/12.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit

class DownloadManager: NSObject {

    let path: String
    let vm = DownloadVM()

    var downloadArray =  [PlayerModel]()
    static let ma = DownloadManager()
    private override init() {
        
        path = GNPath.path()
        let signal = vm.downloadList()
        
        super.init()

        signal.observeCompleted { [unowned self] in

            self.downloadArray.append(contentsOf: self.vm.tableArray)
        }
    }
    
    
}
