//
//  RcdVC.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/3.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MSScrollCell"

class RcdVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    lazy var VC1: UIViewController = {
        
        let vc = UIStoryboard.init(name: "Play", bundle: nil).instantiateViewController(withIdentifier: "PlayVC")
        vc.view.frame = CGRect.init(x: 0, y:kScreenHeight - 50 , width: kScreenWidth, height:kScreenHeight )

//        self.addChildViewController(VC)
        return vc
    }()
    
    //    闭包数组需指定类型
    lazy var collectionArray: Array<Any> =  {
        
        var temp: Array = [Any]()
        var titleArray = ["RcdMainVC","RcdSingerVC","RcdHotVC"]
        for title in titleArray {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: title)
            vc!.view.frame = CGRect.init(x: 0, y:0, width: kScreenWidth, height:self.collectionView.frame.height - 50 )

            print("vc!.view.frame")
            print(vc!.view.frame)
            self.addChildViewController(vc!)
            temp.append(vc as Any)
        }
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let window: UIWindow = UIApplication.shared.delegate!.window as! UIWindow
        window.addSubview(VC1.view)
        
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLeftItem(_ sender: UIBarButtonItem) {
        
        let vc = UIStoryboard.init(name: "Download", bundle: nil).instantiateViewController(withIdentifier: "DownloadNV")
        self.present(vc, animated: true, completion: nil)
    }

    
    @IBAction func onRightItem(_ sender: UIBarButtonItem) {
        
        let vc = UIStoryboard.init(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return .all
    }
    func shouldAutorotate() -> Bool {
        
        return true
    }

}
extension RcdVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return  CGSize.init(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
}

extension RcdVC: UICollectionViewDelegate,UICollectionViewDataSource {
    
     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.collectionArray.count
    }
    
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MSScrollCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MSScrollCell
        let vc: UIViewController = self.collectionArray[indexPath.row] as! UIViewController
        cell.view = vc.view
        
        
        return cell
    }
}
