//
//  RcdScrollView.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/9/23.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit

fileprivate let scrollInterval = 5.0

class RcdScrollView: GNView {

    @IBOutlet weak var page: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    let RcdScrollCell = "RcdScrollCell"
    let vm = RcdVM()
    var collectionViewWIdth: CGFloat = 0.0
    
    lazy var scrollTimer: Timer = {
    
        let timer = Timer.scheduledTimer(timeInterval: scrollInterval, target: self, selector: #selector(self.scroll), userInfo: nil, repeats: true)
        timer.fireDate = Date.distantFuture
        RunLoop.main.add(timer, forMode: .commonModes)
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
    
    
    collectionViewWIdth = self.collectionView.frame.width
    }
    func loadData()  {
        
        vm.getRecommendScrollList().observeCompleted {
            
            self.scrollTimer.fireDate = Date.init(timeIntervalSinceNow: scrollInterval)
            self.collectionView.reloadData()
           self.collectionView.setContentOffset(CGPoint.init(x:self.frame.width, y: 0), animated: false)
        }
    }
    
    func setUI(){
    
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(UINib.init(nibName: RcdScrollCell, bundle: nil), forCellWithReuseIdentifier: "CELL")
        
    }

    @objc func scroll()  {
        
        let offset = self.collectionView.contentOffset.x
        self.collectionView.setContentOffset(CGPoint.init(x:offset + self.frame.width, y: 0), animated: true)
    }
}

extension RcdScrollView: UICollectionViewDelegate {
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
    
        if page.currentPage == 2 {
            
            if (self.collectionView.contentOffset.x > collectionViewWIdth * 2 ) {
                
                self.collectionView.contentOffset.x = self.frame.width
            }
        }
        self.page.currentPage = Int(self.collectionView.contentOffset.x / collectionViewWIdth) - 1
    
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollTimer.fireDate = Date.distantFuture
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        if self.collectionView.contentOffset.x == 0 {
            
            self.collectionView.contentOffset.x = 3 * self.frame.width
        }
        scrollViewDidEndScrollingAnimation(collectionView)
        scrollTimer.fireDate = Date.init(timeIntervalSinceNow: scrollInterval)
    }
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
