//
//  GNWrapper.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/2/27.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit
import ObjectiveC


func wrapperReq(object:AnyObject) -> Dictionary <String,Any> {
        
//        let Ivar = class_copyIvarList(object.classForCoder, &count)
        var dic = [String:Any]()
    
        let r = Mirror.init(reflecting: object)
        
        let rs = r.superclassMirror
        
        for  (label, value) in r.children {
            
            
            dic[label!] = value

//            print("属性名:\(String(describing: label))，值:\(value)")
        }
        for  (label, value) in rs!.children {
            
            dic[label!] = value

//            print("属性名:\(String(describing: label))，值:\(value)")
        }

        return dic
    }
//    @discardableResult
//    class func wrraper(cls :AnyClass, dic: inout Dictionary <String,Any>, object: AnyObject) -> Dictionary <String,Any> {
//
//        var count : UInt32 = 0
//        let Ivar = class_copyIvarList(cls, &count)
//        for i in 0..<count {
//
//            let ivar = Ivar![Int(i)]
//            let ivarName = ivar_getName(ivar)
//            let name = String(cString:ivarName!)
//
//
//            let v  = object[value(forKeyPath: name)]
//
////            let v = object.value(forKey: name)
//
//            dic[name] = v
//        }
//        return dic
//
//    }
