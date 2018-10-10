//
//  RcdScrollCell.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/9/21.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit
import Kingfisher


class RcdScrollCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    var model: RcdScrollModel? {
        willSet {

            guard model?.song_id == newValue?.song_id  else {
                
                imgView.kf.setImage(with: ImageResource.init(downloadURL: URL.init(string: newValue!.pic_big as! String )!) )
                return
                }
            }
    }
}
