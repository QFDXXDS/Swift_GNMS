//
//  DownloadDAO.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/19.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit

class DownloadDAO: DAOProtocol {

    var tableName: String = "DownloadDAO"
    
     var column: [String] = [
        
            "songId INTEGER PRIMARY KEY",
          "songName TEXT",
        "artistName TEXT",
        "songPicBig TEXT",
          "songLink TEXT",
           "lrcLink TEXT",
              "time TEXT",
        ]
    
    class func insertModel(model: PlayerModel) {
        
        
        DAOManager.db { (db) in
            
            let sql = String.init(format: "insert into DownloadDAO values (?,?,?,?,?,?,?)")
            try? db.executeUpdate(sql, values: [model.songId,model.songName,model.artistName,model.songPicBig,model.songLink,model.lrcLink,model.time])
        }
    }
    
    class func fetchData(success: @escaping (Array<PlayerModel>)->Void )  {
        
        DAOManager.db { (db) in
            var temp = [PlayerModel]()

            let sql = String.init(format: "select * from DownloadDAO ")
            do {
             
                let set = try db.executeQuery(sql, values: nil)
                while(set.next())  {
                    
                    var model = PlayerModel()
                    model.songId = Int(set.int(forColumn: "songId"))
                    model.songName = set.string(forColumn: "songName")
                    model.artistName = set.string(forColumn: "artistName")
                    model.songPicBig = set.string(forColumn: "songPicBig")
                    model.songLink = set.string(forColumn: "songLink")
                    model.lrcLink = set.string(forColumn: "lrcLink")
                   temp.append(model)
                }
                
                success(temp)
            }
            catch{
                
                
            }
            
        }
        

    }
    
    
}
