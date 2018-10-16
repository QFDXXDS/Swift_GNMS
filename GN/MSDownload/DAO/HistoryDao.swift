//
//  HistoryDao.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/9/28.
//  Copyright © 2018 XXDS. All rights reserved.
//

import Foundation


class HistoryDao: DAOProtocol {
    
    var tableName: String = "HistoryDao"
    
    var column: [String] = [
        
        "songId INTEGER PRIMARY KEY",
        "songName TEXT",
        "artistName TEXT",
        "songPicBig TEXT",
        "songLink TEXT",
        "lrcLink TEXT",
        "time TEXT",
    ]
    
    class  func isExist(songId: Int) -> Bool {
        
        var result = false
        DAOManager.db { (db) in
            
            let sql = String.init(format: "select *from HistoryDao where songId = ?")
            let set =  try? db.executeQuery(sql, values: [songId])
            
            if set!.next() {
            
                result = true
            }
        }
        
        return result
        
    }
    
    class func insertModel(model: PlayerModel) {
        
        if isExist(songId: model.songId!) {
            
//            DAOManager.db { (db) in
//
//            let sql1 = String.init(format: "delete from HistoryDao where songId = ?")
//            try? db.executeUpdate(sql1, values:[model.songId!])
//            }
            
            return
        }
        
        DAOManager.db { (db) in


            let sql = String.init(format: "insert into HistoryDao values (?,?,?,?,?,?,?)")
            try? db.executeUpdate(sql, values: [model.songId,model.songName,model.artistName,model.songPicBig,model.songLink,model.lrcLink,model.time])
        }
    }
    
    class func fetchData(success: @escaping (Array<PlayerModel>)->Void )  {
        
        DAOManager.db { (db) in
            var temp = [PlayerModel]()
            
            let sql = String.init(format: "select * from HistoryDao ")
            do {
                
                let set = try db.executeQuery(sql, values: nil)
                while(set.next())  {
                    
                    var model = PlayerModel()
                    model.songId = Int(set.int(forColumn: "songId"))
                    model.songName = set.string(forColumn: "songName")
                    model.artistName = set.string(forColumn: "artistName")
                    model.songPicBig = set.string(forColumn: "songPicBig")
//                    model.songLink = set.string(forColumn: "songLink")
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
