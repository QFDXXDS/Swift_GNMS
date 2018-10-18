//
//  SearchReq.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/9/29.
//  Copyright © 2018 XXDS. All rights reserved.
//

import Foundation

class SearchReq: MSReq {
    
    var query: String?
    let size = 20
    
    override func URLStr() -> String {
        
        return MS_LIST_URL
    }

    init(query: String) {
        
        super.init()
        format = "json"
        method = "baidu.ting.search.catalogSug"
        self.query = query
        
    }
    
    required init() {
//        fatalError("init() has not been implemented")
    }
    
    
}
