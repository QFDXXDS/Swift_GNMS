//
//  Const.swift
//  GN
//
//  Created by Xianxiangdaishu on 2017/10/30.
//  Copyright © 2017年 XXDS. All rights reserved.
//

import Foundation
import UIKit

@_exported import Result
@_exported import ReactiveCocoa
@_exported import ReactiveSwift

@_exported import Alamofire
import HandyJSON
import PKHUD


let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width
let KBUTTONTAG = 1000


typealias GNSignal = Signal
typealias GNProducer = SignalProducer
typealias GNNoError = NoError

//typealias GNJSON = JSON
typealias GNHandyJSON = HandyJSON
typealias GNHUD = HUD
typealias GNHUDContentType = HUDContentType



let MS_LIST_URL = "http://tingapi.ting.baidu.com/v1/restserver/ting?"

let MS_SONG_URL = "http://ting.baidu.com/data/music/links"

let kHTTPFAil = NSNotification.Name.init("HTTPFAil")
