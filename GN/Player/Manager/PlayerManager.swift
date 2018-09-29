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

    var name = MutableProperty("")
    var model = MutableProperty(PlayerModel.init())
    
    var playState = MutableProperty(false)
    var duration = MutableProperty("")
    var currentDuration = MutableProperty("")
    var currentValue = MutableProperty(Float(0))
    var buffer = MutableProperty(Float(0))
    
    var history = [PlayerModel]()

    var historyDic = Dictionary<String,PlayerModel>()

    
    

    var totalTime: Int?
    var playItem: AVPlayerItem?
    var observer: Signal<Any, NoError>.Observer?
    var player = AVQueuePlayer()
    
    lazy var timer: Timer = {
        
        let t = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateInfo), userInfo: nil, repeats: true)
        t.fireDate = Date.distantFuture
        return t
    }()
    
    lazy var producer: Signal<Any,NoError>? = {
        
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
            self.currentValue.value = 0.0
            print("AVPlayerItemDidPlayToEndTime")
            
        }
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemNewAccessLogEntry).observe { _ in
            
            print("AVPlayerItemTimeJumped")
            
        }
        
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemNewErrorLogEntry).observe { _ in
            
            self.playState.value = false
            print("AVPlayerItemTimeJumped")
            
        }

        
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemPlaybackStalled).observe { _ in
            
            print("AVPlayerItemPlaybackStalled")
        }
        
        HistoryDao.fetchData { (array) in
            
            if array.count > 0 {
                
                self.history.append(contentsOf: array)
                self.model.value = self.history[0]
                self.name.value = self.model.value.songName as! String

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
            
            duration.value = String.stringWithSeconds(seconds: durationTime())
            timer.fireDate = Date.distantPast
            self.observer?.send(Signal<Any, NoError>.Event.value(""))

        case .failed:
            print("unknown")

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
        ma.name.value = ma.model.value.songName as! String
        HistoryDao.insertModel(model: ma.model.value)
        ma.player.replaceCurrentItem(with: ma.playItem)
        
        print("ma.player.items() is \(ma.player.items())")

        self.play(true)
        
        ma.playItem?.addObserver(ma, forKeyPath: "status", options: [.new,.old], context: nil)   //  系统提供可以直接使用addObserver
        ma.playItem?.addObserver(ma, forKeyPath: "loadedTimeRanges", options: [.new,.old], context: nil)

        
//        ma.timer.fireDate = Date.distantFuture
        ma.observer!.send(Signal.Event.completed)  // k获取歌词
        
        
    }
    class func play(_ play: Bool)  {
        
        if ma.playItem == nil {
            
            if ma.history.count > 0 {
                PlayerManager.play(url: URL.init(string: ma.model.value.songLink as! String)!)
            }
        } else {
            
            play ? ma.player.play() : ma.player.pause()
            ma.timer.fireDate = Date.distantFuture
            ma.playState.value = play
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
            
            return model.songId as! Int == ma.model.value.songId as! Int
        }

        if index! < ma.history.count && index! > 0   {

            ma.model.value = ma.history[index! - 1]
            PlayerManager.play(url: URL.init(string: ma.model.value.songLink as! String)!)

        }

    }
    class func next()  {
       
        ma.timer.fireDate = Date.distantFuture
//        ma.player.advanceToNextItem()
        let index = ma.history.firstIndex { (model) -> Bool in

            return model.songId  == ma.model.value.songId
        }
        if index! < ma.history.count - 1 && ma.history.count > 1  {

            ma.model.value = ma.history[index! + 1]
            PlayerManager.play(url: URL.init(string: ma.model.value.songLink as! String)!)

        }

        
    }
 
}

extension  PlayerManager  {
    
    
    class func  playWithSongID(_ songID: String)  {
    
        if ma.historyDic[songID] == nil {
            
            PlayerService.getSong(singID: songID, success: { (rsp) in
                
                let m = PlayerModel.wrraperData(object: rsp)
                ma.model.value = m
                ma.history.append(m)
                ma.historyDic[songID] = m
                
                PlayerManager.play(url: URL.init(string: ma.model.value.songLink as! String)!)
            }, fail: { (err) in
                
            })
        } else {
            
            ma.model.value = ma.historyDic[songID]!
            PlayerManager.play(url: URL.init(string: ma.model.value.songLink as! String)!)

        }
    }

}
