//
//  GNHTTPProtocol.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/2/28.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import Alamofire

protocol GNHTTPProtocol {
    
    func parameters() -> Dictionary<String, Any>
    func reqMethod() -> HTTPMethod
    func URLStr() -> String
    func downloadFile() -> String

}

