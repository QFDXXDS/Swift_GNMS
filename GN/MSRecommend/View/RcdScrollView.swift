//
//  RcdScrollView.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/9/23.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit

class RcdScrollView: GNView {

    @IBOutlet weak var page: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    let RcdScrollCell = "RcdScrollCell"
    let vm = RcdVM()
    lazy var scrollTimer: Timer = {
    
        let timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.scroll), userInfo: nil, repeats: true)
        timer.fireDate = Date.distantFuture
       return timer
    }()

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
   override func createView() {
    

    loadData()
    setUI()
        
    }
    func loadData()  {
        
        vm.getRecommendScrollList().observeCompleted {
            
            self.scrollTimer.fireDate = Date.init(timeIntervalSinceNow: 2)
            self.collectionView.reloadData()
        }
    }
    
    func setUI(){
    
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: RcdScrollCell, bundle: nil), forCellWithReuseIdentifier: "CELL")
    }

    @objc func scroll()  {
        
//        print("123123")
        self.collectionView.setContentOffset(CGPoint.init(x: self.frame.width, y: 0), animated: true)
    }
    
}

extension RcdScrollView: UICollectionViewDelegate {
    
    
    
}

extension RcdScrollView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.collectionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:RcdScrollCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CELL", for: indexPath) as! RcdScrollCell
        
        cell.model = vm.collectionArray[indexPath.row] as? RcdScrollModel
    
        return cell
    }
    
}

extension RcdScrollView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return  CGSize.init(width:kScreenWidth  , height: self.frame.height)
    }
}

