//
//  PlayerView.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/6.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result


class PlayerView: GNView {

    
    @IBOutlet weak var forwardBt: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playBt: UIButton!
    @IBOutlet weak var progressBt: UIButton!
    
    
    @IBOutlet weak var downloadBt: UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    
    override func createView() {
        
        nameLabel.reactive.text <~ PlayerManager.ma.name
        playBt.reactive.isSelected <~ PlayerManager.ma.playState
        nameLabel.reactive.text <~ PlayerManager.ma.name
        forwardBt.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
        self.progressBt.isHidden = true
    }
    
    @IBAction func onButton(_ sender: UIButton) {
        
        switch (sender.tag - KBUTTONTAG) {
            
        case 0:
            
            PlayerManager.forword()
        case 1:
            PlayerManager.play(!sender.isSelected)
        case 2:
            PlayerManager.next()
        case 3:
            download()
            
        default: break
            
        }
    }
    
    func download() {
    
        DownloadVM.download(model: PlayerManager.ma.vm.model.value).observeValues { (v) in
            
            self.progressBt.setTitle(v as! String, for: .normal)

            let progress = Int(v as! String)
            if progress! > 99 {
                
                self.progressBt.isHidden = true
                self.downloadBt.isHidden = false
                
            } else {
                
                self.progressBt.isHidden = false
                self.downloadBt.isHidden = true
            }
        }
    }
}
