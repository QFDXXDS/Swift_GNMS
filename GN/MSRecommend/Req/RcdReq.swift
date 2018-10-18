//
//  MSRecommendReq.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/2/27.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit

  class RcdListReq: MSReq {

   let limits = 50
   let order = 1
   let page_no = 1
    var page: Int?
    var size: Int?
    
   override func URLStr() -> String {

        return MS_LIST_URL
    }
    
//    required init() {
//        super.init()
//    }

    
}


//struct RcdListReq {
//
//    let limits = 50
//    let order = 1
//    let page_no = 1
//    let page =  1
//    let size = 50
//
//    init(page: Int, size: Int) {
//
//
//    }
//
//
//
//}

class RcdListScrollReq: MSReq {
    
    let size = 10
    
    override func URLStr() -> String {
        
        return MS_LIST_URL
    }

}


