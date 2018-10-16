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
    
    class func fetchData(songId: Int?, success: @escaping (Array<PlayerModel>)->Void )  {
        
        DAOManager.db { (db) in
            
            do {

            var temp = [PlayerModel]()

            var sql: String
            var set: FMResultSet
            if songId == nil {
                
                sql = String.init(format: "select * from DownloadDAO ")
                set = try db.executeQuery(sql, values: nil)
            } else {
                sql = String.init(format: "select * from DownloadDAO where songId = ?")
                set = try db.executeQuery(sql, values: [songId])
            }
                while(set.next())  {
                    
                    var model = PlayerModel()
                    model.songId = Int(set.int(forColumn: "songId"))
                    model.songName = set.string(forColumn: "songName")
                    model.artistName = set.string(forColumn: "artistName")
                    model.songPicBig = set.string(forColumn: "songPicBig")
                    model.lrcLink = set.string(forColumn: "lrcLink")
                
//                  返回本地路径
                    
                    let path = GNPath.cachePath() + "/" + "music/" + "\(model.songId!)" + ".mp3"
                    model.songLink = path

                   temp.append(model)
                }
                success(temp)
            }
            catch{
                
                
            }
            
        }
        

    }
    
    class func isExist(songId: Int) -> Bool {
        
        var result = false
        DAOManager.db { (db) in
        
            do {
                let sql = String.init(format: "select *from DownloadDAO where songId = ?")

                let set = try db.executeQuery(sql, values: [songId])
                
                if set.next() {
                    
                    result = true
                }
            } catch {
                
                
            }
        }
        return result
    }
    
    

    
}
