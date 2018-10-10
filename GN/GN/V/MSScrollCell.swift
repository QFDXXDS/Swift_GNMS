//
//  MSScrollCell.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/9/22.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit

class MSScrollCell: UICollectionViewCell {
    
    
//    required init?(coder aDecoder: NSCoder) {
//
//        super.init(coder: aDecoder)
//    }
    
    
    var view: UIView? {
        
        willSet {
            
            guard newValue === view  else {
                
                
                print(newValue?.frame)
                let  v = newValue
//                v.frame = self.contentView.frame
                self.contentView.addSubview(v!)
                return
            }
        }
    }
}
