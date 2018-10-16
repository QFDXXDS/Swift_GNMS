//
//  MSListCell.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/2/27.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit
import Kingfisher
import ReactiveSwift



class MSListCell: UITableViewCell {

    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var artist_name: UILabel!
    
    @IBOutlet weak var playBt: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    
    var model: RcdModel? {
        
        willSet {
            
            playState(songID: (newValue?.song_id)!)
            
            guard  model?.song_id == newValue?.song_id else{
//
//                title.text = model![keyPath: \RcdModel.title] as! String
                title.text = newValue?.title as? String
      //          强制类型检查  format: "%02@:%02@", 报错
                time.text = String.init(format: "%02d:%02d", (newValue?.file_duration as! Int)/60,(newValue?.file_duration as! Int)%60)
                artist_name.text = newValue?.artist_name as? String

                imgView.kf.setImage(with: ImageResource(downloadURL: URL(string: newValue?.pic_big as! String)!))
                
                return
            }
            
        }
    }
    @IBAction func onButton(_ sender: UIButton) {
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()

        PlayerManager.ma.playSignal.observeValues({ [weak self] (_) in
        
            self?.playState(songID: (self?.model!.song_id)!)
        })
    }
    
    func playState(songID: Int) {
        
        
        if songID == PlayerManager.ma.vm.model.value.songId   {
            
            self.playBt.isSelected = PlayerManager.ma.playState.value
        } else {
            
            self.playBt.isSelected = false
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
