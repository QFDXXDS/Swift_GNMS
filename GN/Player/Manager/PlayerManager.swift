//
//  PlayerManager.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/6.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit
import AVFoundation

import ReactiveCocoa
import ReactiveSwift
import Result

class PlayerManager: NSObject {

    let vm = PlayerVM()
    
    var name = MutableProperty("")
    
    var playState = MutableProperty(false)
    var duration = MutableProperty("")
    var currentDuration = MutableProperty("")
    var currentValue = MutableProperty(Float(0))
    var buffer = MutableProperty(Float(0))
    
    
    var history = [PlayerModel]()
    var historyDic = Dictionary<Int,PlayerModel>()

    
    var totalTime: Int?
    var playItem: AVPlayerItem?
    var observer: Signal<Any, NoError>.Observer?
    var player = AVQueuePlayer()
    
    lazy var timer: Timer = {
        
        let t = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateInfo), userInfo: nil, repeats: true)
        t.fireDate = Date.distantFuture
        return t
    }()
    
    lazy var playSignal: Signal<Any,NoError>? = {
        
        let (signal,ob) = Signal<Any, NoError>.pipe()
        self.observer = ob
        
        return signal
    }()
    
    
    
    static let ma = PlayerManager()
    private override init() {
        
        super.init()

        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemPlaybackStalled).observe { _ in
            
            print("AVPlayerItemPlaybackStalled")

        }
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemNewAccessLogEntry).observe { _ in
            
            print("AVPlayerItemNewAccessLogEntry")
            
        }
        
        
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemDidPlayToEndTime).observe { _ in
            
            self.timer.fireDate = Date.distantFuture
            self.currentValue.value  = 0.0
            self.buffer.value = 0.0
            self.playState.value = false
            self.observer?.send(value: false)

            self.currentValue.value = 0.0
            print("AVPlayerItemDidPlayToEndTime")
            
        }
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemNewAccessLogEntry).observe { _ in
            
            print("AVPlayerItemTimeJumped")
        }
        
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemNewErrorLogEntry).observe { _ in
            
            self.playState.value = false
            self.observer?.send(value: false)

            print("AVPlayerItemTimeJumped")
            
        }

        
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemPlaybackStalled).observe { _ in
            
            print("AVPlayerItemPlaybackStalled")
        }
        
        
        HistoryDao.fetchData { (array) in
            
            if array.count > 0 {
                
//                self.history.append(contentsOf: array)
                self.vm.model.value = array[0]
                self.name.value = self.vm.model.value.songName as! String
            }
        }
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
//        print("keypath is \(keyPath)  \(change![NSKeyValueChangeKey.newKey])")
        
        if keyPath == "status" {
            
            self.updatePlayerStatus()
        } else if keyPath == "loadedTimeRanges" {
            
            if totalTime != nil {
                
                let timeRange = (self.playItem!.loadedTimeRanges.first)!.timeRangeValue
                let startSeconds = CMTimeGetSeconds(timeRange.start);
                let durationSeconds = CMTimeGetSeconds(timeRange.duration);
                
                buffer.value = Float((startSeconds + durationSeconds)) / Float(totalTime!)
                

                if !playState.value {
                    
                    playState.value = true
                    self.observer?.send(value: true)
                }
                print("loadedTimeRanges is \(buffer.value)")
                
            }
        }
    }
    
    @objc func updateInfo()  {
        
        let item = self.player.currentItem
        let length = item?.currentTime()
        let current = Int(CMTimeGetSeconds((length)!))
        currentDuration.value =  String.stringWithSeconds(seconds: current)
        currentValue.value = Float(current) / Float(totalTime!)
    }

    
    func updatePlayerStatus()  {
        
        switch playItem!.status {
            
        case .unknown:
            
            print("unknown")
        case .readyToPlay:
            
            playState.value = true
            self.observer?.send(value: true)
            duration.value = String.stringWithSeconds(seconds: durationTime())
            timer.fireDate = Date.distantPast
            
        case .failed:

            self.playState.value = false
            self.observer?.send(value: false)
        }
    }
    
    func durationTime() -> Int {
        
//        let item = self.player.currentItem
        let length = CMTimeGetSeconds(self.playItem!.duration)
        if !length.isNaN {
            
            totalTime = Int(length)
        }
        return totalTime!
    }
}



extension PlayerManager {
    
    class func play(url: URL) {
        
        ma.playItem = AVPlayerItem.init(url: url)
        ma.name.value = ma.vm.model.value.songName as! String
        HistoryDao.insertModel(model: ma.vm.model.value)
        ma.player.replaceCurrentItem(with: ma.playItem)
        
        
        ma.player.play()
        
        ma.playItem?.addObserver(ma, forKeyPath: "status", options: [.new,.old], context: nil)   //  系统提供可以直接使用addObserver
        ma.playItem?.addObserver(ma, forKeyPath: "loadedTimeRanges", options: [.new,.old], context: nil)
    }
    class func play(_ play: Bool)  {
        
        if ma.playItem == nil {
            
//            if ma.history.count > 0 {
            
//                PlayerManager.play(url: URL.init(string: ma.vm.model.value.songLink as! String)!)
                PlayerManager.playWithSongID(ma.vm.model.value.songId!)
                
//            }
        } else {
            
            if play {
                
                ma.player.play()
            } else {
                
                ma.playState.value = false
                ma.observer?.send(value: false)

                ma.player.pause()
            }
            ma.timer.fireDate = Date.distantFuture
        }
    }
    
    
    class func seek(value: Float)  {
        
        if  ma.totalTime != nil {
            
            let v =  Float(ma.totalTime!) * value
            ma.player.seek(to: CMTime.init(value: CMTimeValue(v), timescale: 1))
        }
    }
    
    class func forword()  {
        
        ma.timer.fireDate = Date.distantFuture

        let index = ma.history.firstIndex { (model) -> Bool in
            
            return model.songId  == ma.vm.model.value.songId
        }

        if index! < ma.history.count && index! > 0   {

            ma.vm.model.value = ma.history[index! - 1]
            PlayerManager.play(url: URL.init(string: ma.vm.model.value.songLink as! String)!)

        }

    }
    class func next()  {
       
        ma.timer.fireDate = Date.distantFuture
//        ma.player.advanceToNextItem()
        let index = ma.history.firstIndex { (model) -> Bool in

            return model.songId  == ma.vm.model.value.songId
        }
        if index! < ma.history.count - 1 && ma.history.count > 1  {

            ma.vm.model.value = ma.history[index! + 1]
            PlayerManager.play(url: URL.init(string: ma.vm.model.value.songLink as! String)!)
        }
    }
 }

extension  PlayerManager  {
    
    class func  playWithSongID(_ songID: Int) -> GNSignal<Any, GNNoError>  {
    
        let (signal, ob) = GNSignal<Any, GNNoError>.pipe()
        if ma.historyDic[songID] == nil {
        
            ma.vm.getSong(singID: songID).observeCompleted {
            
                ma.history.append( ma.vm.model.value)
                ma.historyDic[songID] = ma.vm.model.value
                PlayerManager.play(url: URL.init(string: ma.vm.model.value.songLink as! String)!)
                ob.sendCompleted()
            }
        } else {
            
            ma.vm.model.value = ma.historyDic[songID]!
            PlayerManager.play(url: URL.init(string:  ma.vm.model.value.songLink as! String)!)
            ob.sendCompleted()
        }
        return signal
    }
    
}

//http://zhangmenshiting.qianqian.com/data2/music/91da8a2655f5d8aed0863451f7a43901/596916037/124415468158400128.mp3?xcode=e9015c8b6d638aaa0fd1a9e14bd081d7

//http://zhangmenshiting.qianqian.com/data2/music/91da8a2655f5d8aed0863451f7a43901/596916037/124415468158400128.mp3?xcode=e9015c8b6d638aaa0fd1a9e14bd081d7

//http://zhangmenshiting.qianqian.com/data2/music/91da8a2655f5d8aed0863451f7a43901/596916037/124415468158400128.mp3?xcode=2d1d9655cc558c50b169a51e193c0fa9
