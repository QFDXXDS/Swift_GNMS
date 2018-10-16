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
    
    
    var history = MutableProperty([PlayerModel]())
    var historyDic = Dictionary<Int,PlayerModel>()
    var PlayerItemDic = Dictionary<Int,AVPlayerItem>()

    
    var totalTime: Int?
    var playItem: AVPlayerItem?
    var player = AVQueuePlayer()
    
    var playSignal: Signal<Any, NoError>
    var observer: Signal<Any, NoError>.Observer

    var dispose: Disposable?
    
    lazy var timer: Timer = {
        
        let t = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateInfo), userInfo: nil, repeats: true)
        t.fireDate = Date.distantFuture
        return t
    }()
    
    
    static let ma = PlayerManager()
    private override init() {
        
        (playSignal,observer) = Signal<Any, NoError>.pipe()
        super.init()
        
        name <~ vm.name
        history <~ vm.history
        
        
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemPlaybackStalled).observe { _ in
            
            print("AVPlayerItemPlaybackStalled")

        }
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemNewAccessLogEntry).observe { (nty) in
            
//            let n = nty.value as? Notification
//            print(n?.object)
//            print(n?.userInfo)
//
//            print("AVPlayerItemNewAccessLogEntry")
            
        }
        
        
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemDidPlayToEndTime).observe { _ in
            
            self.timer.fireDate = Date.distantFuture
            self.currentValue.value  = 0.0
            self.buffer.value = 0.0
            self.playState.value = false
            self.observer.send(value: false)
            self.currentValue.value = 0.0
            print("AVPlayerItemDidPlayToEndTime")
            
        }
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemNewAccessLogEntry).observe { (nty) in
            
//            let n = nty.value as? Notification
//            print(n?.object)
//            print(n?.userInfo)
//
//            print("AVPlayerItemTimeJumped")
        }
        
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemNewErrorLogEntry).observe { _ in
            
            self.playState.value = false
            self.observer.send(value: false)

            print("AVPlayerItemTimeJumped")
            
        }

        
        NotificationCenter.default.reactive.notifications(forName: Notification.Name.AVPlayerItemPlaybackStalled).observe { _ in
            
            print("AVPlayerItemPlaybackStalled")
        }
        
    }

    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
//        print("keypath is \(keyPath)  \(change![NSKeyValueChangeKey.newKey])")
        
        if keyPath == "status" {
            
            self.updatePlayerStatus()
        } else if keyPath == "loadedTimeRanges" {
            
            if totalTime != nil {
                
                if playItem != nil {
                    
                    let timeRange = (self.playItem!.loadedTimeRanges.first)?.timeRangeValue
                    if timeRange != nil {
                        
                        let startSeconds = CMTimeGetSeconds(timeRange!.start);
                        let durationSeconds = CMTimeGetSeconds(timeRange!.duration);
                        buffer.value = Float((startSeconds + durationSeconds)) / Float(totalTime!)
                    }
                    
                    print("loadedTimeRanges is \(buffer.value)")

                }
                
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
            
            self.playState.value = false
            self.observer.send(value: false)
        case .readyToPlay:
            
            duration.value = String.stringWithSeconds(seconds: durationTime())
            timer.fireDate = Date.distantPast
            
        case .failed:

            GNHUD.flash(GNHUDContentType.labeledError(title: nil, subtitle: "s播放失败"))
            self.playState.value = false
            self.observer.send(value: false)
        }
    }
    
    func durationTime() -> Int {
        
        let length = CMTimeGetSeconds(self.playItem!.duration)
        if !length.isNaN {
            
            totalTime = Int(length)
        }
        return totalTime!
    }
}



extension PlayerManager {
    
    class func play(url: String) {
        
        let item = ma.PlayerItemDic[ma.vm.model.value.songId!]
        if item == nil {
            
            ma.playItem = AVPlayerItem.init(url: URL.genaralURL(urlStr: url))
            ma.PlayerItemDic[ma.vm.model.value.songId!] = ma.playItem
        } else {
            
            ma.playItem = item
            ma.player.seek(to: CMTime.init(value: CMTimeValue(0), timescale: 1))
        }
        ma.player.replaceCurrentItem(with: ma.playItem)
        
        
        
        ma.playItem?.addObserver(ma, forKeyPath: "status", options: [.new,.old], context: nil)   //  系统提供可以直接使用addObserver
        ma.playItem?.addObserver(ma, forKeyPath: "loadedTimeRanges", options: [.new,.old], context: nil)
        
        HistoryDao.insertModel(model: ma.vm.model.value)
    }
    

    class func play(_ play: Bool)  {
        
        if ma.playItem != nil {
            
            if play {
                
                ma.player.play()
            } else {
                
                ma.player.pause()
            }
            ma.playState.value = play
            ma.observer.send(value: play)
            ma.timer.fireDate = Date.distantFuture
        } else {
            
            getSong(songID: ma.vm.model.value.songId!)

//            PlayerManager.playWithSongID(ma.vm.model.value.songId!)
        }
    }
    
    class func nextOrForward(next: Bool ){
        
        ma.timer.fireDate = Date.distantFuture
        
        if ma.history.value.count > 1 {
            
            let index = ma.history.value.firstIndex { (model) -> Bool in

                return model.songId  == ma.vm.model.value.songId
            }
            
            var model: PlayerModel

            if next  {
                
               if index == ma.history.value.count - 1 {
                    
                    model = ma.history.value[0]
                } else {
                    model = ma.history.value[index! + 1]
                }
                playModel(model: model)
            }
            if !next  {
                
                if index == 0 {
                    
                    model = ma.history.value[ma.history.value.count - 1]
                } else {
                    model = ma.history.value[index! - 1]
                }

                playModel(model: model)

            }
        }
    }
    class func playModel(model: PlayerModel) {
        
        //              有些歌曲链接会失效，历史记录不读取歌曲链接
        if model.songLink != nil {
        
            ma.name.value = model.songName as! String
            ma.vm.model.value = model
            PlayerManager.play(url: model.songLink!)
            
        } else {

            getSong(songID: model.songId!)
        }
    }
    
    class func seek(value: Float)  {
        
        if  ma.totalTime != nil {
            
            let v =  Float(ma.totalTime!) * value
            ma.player.seek(to: CMTime.init(value: CMTimeValue(v), timescale: 1))
        }
    }

 }

extension  PlayerManager  {
    
    class func  playWithSongID(_ songID: Int)  {
    
        if songID == ma.vm.model.value.songId && ma.playItem != nil {

            ma.playState.value ? self.play(false) : self.play(true)
            return
        }
        //      通过点击时排在最前面
        ma.history.value.removeAll { (model) -> Bool in

            if model.songId == songID {

                return true
            }
            return false
        }
        getSong(songID: songID)
    }
    
    class func getSong(songID: Int){
        
       ma.dispose = ma.vm.getSong(songID: songID).observeCompleted {
            
            let i = ma.history.value.firstIndex(where: { (model) -> Bool in
                
                return model.songId! == ma.vm.model.value.songId!
            })
            if i == nil {
                
                ma.history.value.append( ma.vm.model.value)
            } else {
                
                ma.history.value[i!] = ma.vm.model.value
            }
            PlayerManager.play(url:  ma.vm.model.value.songLink! )
        }
    }
}
