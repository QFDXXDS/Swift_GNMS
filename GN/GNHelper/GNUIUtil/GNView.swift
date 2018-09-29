//
//  GNView.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/9/23.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit

class GNView: UIView {

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initial()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initial()
    }
    
    func initial()  {
        
        var s:String =  NSStringFromClass(type(of: self))
        s.removeFirst(3)
        let view:UIView = Bundle.main.loadNibNamed(s, owner: self, options: nil)?.first as! UIView
        view.frame = self.frame
        self.addSubview(view)
        
        self.createView()
    }
    
    func createView()  {
    
    
    }
    
}
