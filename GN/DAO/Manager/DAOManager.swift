//
//  DAOManager.swift
//  GN
//
//  Created by Xianxiangdaishu on 2018/3/14.
//  Copyright © 2018年 XXDS. All rights reserved.
//

import UIKit
import FMDB


class DAOManager: NSObject {

    let dbQueue: FMDatabaseQueue
    let dbPath = GNPath.docuemntPath() + "/SQLite.db"

    static let  ma = DAOManager()
    
    private override init() {
        
        dbQueue = FMDatabaseQueue.init(path: dbPath)
        
        super.init()
    }
    class func createDAO()  {
     
        self.ma
        DAOManager.createDAO(ptl: DownloadDAO())
        DAOManager.createDAO(ptl: HistoryDao())

    }

   fileprivate class func createDAO(ptl: DAOProtocol)  {
        
         self.db({ (db) in
            
//            let cls = type(of: ptl)
        
           try? db.executeUpdate("create table if not exists  \(ptl.tableName) (\(self.column(column: ptl.column))) ", values: nil)

        })
    }
    
    class func db(_ block:(FMDatabase) -> Void)  {
        
        self.ma.dbQueue.inDatabase(block)
    }
    
    class func transaction(_ block:(FMDatabase, UnsafeMutablePointer<ObjCBool>) -> Void)  {   // 支持事物
        self.ma.dbQueue.inTransaction(block)
    }
    
}

extension DAOManager {
    
    class  func column(column: [String]) -> String {
        
        
        return column.joined(separator: ",")
    }

}

