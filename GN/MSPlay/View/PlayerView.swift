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

    let vm = PlayViewModel()
    
    override func createView() {
        
        nameLabel.reactive.text <~ PlayerManager.ma.name
        playBt.reactive.isSelected <~ PlayerManager.ma.playState
        
        downloadBt.reactive.isEnabled <~ vm.isEable
        progressBt.reactive.isHidden <~ vm.progressHide

        PlayerManager.ma.playSignal.observeValues({ (_) in
            
           self.vm.isDownload()
        })
        
        
        forwardBt.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
        self.vm.isDownload()
    }
    
    @IBAction func onButton(_ sender: UIButton) {
        
        switch (sender.tag - KBUTTONTAG) {
            
        case 0:
            
            PlayerManager.nextOrForward(next: false)
        case 1:
            PlayerManager.play(!sender.isSelected)
        case 2:
            PlayerManager.nextOrForward(next: true)
        case 3:
            download()
            
        default: break
            
        }
    }
    
    func download() {
    
        self.progressBt.isHidden = false
        self.downloadBt.isHidden = true

        let signal = vm.download(model: PlayerManager.ma.vm.model.value)
            
        signal.observeValues { (v) in
            
            self.progressBt.setTitle(v as! String, for: .normal)
        }
        signal.observeCompleted {
            
            self.progressBt.isHidden = true
            self.downloadBt.isHidden = false
        }
    }
}
