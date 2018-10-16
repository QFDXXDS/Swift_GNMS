//
//  PlayVC.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/6.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa
import Result


let y = kScreenHeight - 50

class PlayVC: UIViewController {

    let playView = PlayerView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 50))
    
    let vm = DownloadVM()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playBt: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var currentDurationLabel: UILabel!
    
    @IBOutlet weak var durationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.playView)
        self.addObserver(self, forKeyPath: "view.frame", options: [.new,.old], context: nil)   //  系统提供可以直接使用addObserver
        
        tableView.delegate = self
        tableView.dataSource = self
        addGes()
        
    
        setUI()
//        self.view.addGestureRecognizer(rightGes)

        // Do any additional setup after loading the view.
    }
    func setUI()  {
    
        playBt.reactive.isSelected <~ PlayerManager.ma.playState
        nameLabel.reactive.text <~ PlayerManager.ma.name
        slider.reactive.value <~  PlayerManager.ma.currentValue
        
        currentDurationLabel.reactive.text <~ PlayerManager.ma.currentDuration
        durationLabel.reactive.text <~ PlayerManager.ma.duration
        progressView.reactive.progress <~ PlayerManager.ma.buffer
        
        slider.reactive.values.observeValues { (v) in
            
            PlayerManager.seek(value: v)
            }
        
        PlayerManager.ma.playSignal.observeValues({ (v) in
            
            //            self.vm.downloadLyric(model: PlayerManager.ma.model.value).observeCompleted({
            //
            //                self.tableView.reloadData()
            //            })

        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func pantap(sender: UIScreenEdgePanGestureRecognizer)  {
        
        if sender.edges == .left {
            
            print(123)
        } else if sender.edges == .right {
            
            print(321)

        }

    }

    deinit {
        
        self.removeObserver(self, forKeyPath: "view.frame")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "view.frame" {
            
//            print("change \(change?[.newKey] )")
            
//            if !self.view.subviews.contains(self.playView) {
//
//                self.view.addSubview(self.playView)
//            }
//            self.playView.isHidden = false

        }
    }
    
    @IBAction func onchangeFramButton(_ sender: UIButton?) {
        
        var frame: CGRect
        if y == self.view.frame.minY {
           
             frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
        } else {
             frame = CGRect.init(x: 0, y: y, width: kScreenWidth, height: kScreenHeight)

        }
        changeFrame(frame: frame)

    }
    
    func changeFrame(frame: CGRect)  {
        
//        UIView.animate(withDuration: 0.3, animations: {
//
//            self.view.frame = frame
//        }, completion:{ (completion ) in
//
//            if frame.minY == y {
//
//                self.playView.isHidden = false
//            }
//        })
    }

    @IBAction func onTapGesture(_ sender: UITapGestureRecognizer) {
        
        let y = kScreenHeight - 50

        if y == self.view.frame.minY {
            
//            onchangeFramButton(nil)
//            self.playView.isHidden = true
        }
    }
    
    func  addGes()  {
    
        let leftGes = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(pantap(sender:)))
            leftGes.edges = .left
        self.view.addGestureRecognizer(leftGes)
        
        let rightGes = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(pantap(sender:)))
        rightGes.edges = .right
        self.view.addGestureRecognizer(rightGes)

    }

    @IBAction func onEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
        
        print(sender.edges)
    }
    
    @IBAction func onCtrlBt(_ sender: UIButton) {
        
        switch sender.tag - 1000 {
        
        case 2:
            
            PlayerManager.play(!sender.isSelected)

//        case 3:
        case 4:
//            vm.download(model: PlayerManager.ma.vm.model.value)
            break
        default:
            break
        }
    }
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//  MARK: gesture
extension PlayVC {
    
    
    

}

extension PlayVC: UITableViewDelegate {
    
    
}

extension PlayVC: UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        print("\(vm.lyricArray)")
        return vm.lyricArray.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        
        let sub = vm.lyricArray[indexPath.row]
        let s = sub.split(separator: "]")
        if s.count > 1 {
            
            cell.textLabel?.text = String(s[1])
        } else {
            cell.textLabel?.text = ""
        }
        
        return cell
    }

    
}
