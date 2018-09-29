//
//  GNHTTPManager.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/9/21.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import Foundation
import Alamofire


func HTTPRequesgt(
            req: GNHTTPReq,
        success: @escaping (Any?,Any?)->Void )  {
    
    Alamofire.request(req.URLStr(), method: req.reqMethod(), parameters: req.parameters()).responseJSON { (rsp) in
        
        switch rsp.result {
            
        case .success(_):
            
            success(rsp.result.value as Any  , nil)
            break
            
        case .failure(_):
            success(nil, rsp.error)
            
            break
            
        }
    }
}

func HTTPDownload(
    req: GNHTTPReq,
    success: @escaping (Any?,Any?)->Void, downloadProgress: @escaping (String) -> Void ) {
    
    
    let downloadConfig : DownloadRequest.DownloadFileDestination = {_,response in
        
        //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
        
        let  url: URL = URL.init(fileURLWithPath: req.downloadFile())
        
        return (url, [.removePreviousFile, .createIntermediateDirectories])
    }
    
    Alamofire.download(req.URLStr(), parameters: nil, to: downloadConfig).downloadProgress { (progress) in
        
//        if downloadProgress {
        
            let  pp = (Float(progress.completedUnitCount) / Float(progress.totalUnitCount)) * 100
            let s = String(format: "%.0f", pp)
            downloadProgress(s)
//        }
                
        }.responseData { (rsp) in
            
            switch rsp.result {
                
            case .success(let value):
                
                success(value , nil)
                break
                
            case .failure(_):
                success(nil, rsp.error)
                
                break
                
            }
            
            
    }
    
    
}
