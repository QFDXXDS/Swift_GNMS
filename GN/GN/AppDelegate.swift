//
//  AppDelegate.swift
//  GN
//
//  Created by Xianxiangdaishu on 2017/10/30.
//  Copyright © 2017年 XXDS. All rights reserved.
//

import UIKit

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


//    func add(_ num: Int) -> () -> Int {
//
//
//        let v = 2
//        func a() -> Int {
//
//            print("func is \(#function)")   //a()
//            print("func is \(#line)")  //行号
//            print("func is \(#file)")  // /Users/xxds/Desktop/GN-MS/GN/GN/AppDelegate.swift
//                print("func is \(#column)")  //列编号
//
//            return v + num
//        }
//        return a
//    }


    
     func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        addObserver()
//        setConfig()
//        var dic = [String:Any]()
//        dic["123"] = 44
//        "qwe".lengthOfBytes(using: .unicode)
//        "qwe".lengthOfBytes(using: .ascii)
//        "qwe".count
//
//
//        print("rewtweyweuewuw");
//        let addTwo = add(2)(), addFour = add(4)(), addSix = add(6), addEight = add(8)
//
//
//
//        var a = ["333","wewer"]
//        a.remove(at: 1)
      
        config()
        return true
    }

    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        
//        let addTwo = add(2)(), addFour = add(4)(), addSix = add(6), addEight = add(8)
//        var a = ["333","wewer"]
//        a.remove(at: 1)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask{
        
        return .portraitUpsideDown
    }

}

extension AppDelegate {
    
    func addObserver()  {
        
        self.addObserver(self, forKeyPath: "window.rootViewController", options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "window.rootViewController" {
            
            print(" ")
        }
    }
}

extension AppDelegate {
    
    
    func config()  {
        
        DAOManager.createDAO()
        
        GNHUD.dimsBackground = true
        
    }


}

extension AppDelegate {
    
    func addNotification()  {
        
        NotificationCenter.default.reactive.notifications(forName: kHTTPFAil, object: nil).observeValues { (n) in
            
            let desc = n.object as! String
            GNHUD.flash(GNHUDContentType.labeledError(title: nil, subtitle: desc), delay: 1.0)
            
        }
    }
    
}
