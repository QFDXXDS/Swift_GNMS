
//
//  WSProtocol.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/2/27.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import Foundation

protocol MSReqProtol {
    
    func parameters() -> Dictionary<String, Any>
    func reqMethod() -> String
}

protocol MSDataProtol {
    
    
}

protocol DAOProtocol {
    
     var column: [String] { get }
     var tableName: String { get }
}

