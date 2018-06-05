//
//  RainbowSQLManage.swift
//  RainbowTable
//
//  Created by 张瑜 on 2018/5/6.
//  Copyright © 2018年 张瑜. All rights reserved.
//
/*
 This class controls all of the sqlite functions.
 */
import Foundation

class SQLiteManager: NSObject {
    //MARK: - 创建类的静态实例变量即为单例对象 let-是线程安全的
    static let instance = SQLiteManager()
    //对外提供创建单例对象的接口
    class func shareInstance() -> SQLiteManager {
        return instance
    }
    //MARK: - 数据库操作
    //定义数据库变量
    var db : OpaquePointer? = nil
    
    //打开数据库
    func openDB() -> Bool {
        //数据库文件路径
        let dicumentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last
        let DBPath = (dicumentPath! as NSString).appendingPathComponent("appDB.sqlite")
        let cDBPath = DBPath.cString(using: String.Encoding.utf8)
        //打开数据库
        //第一个参数:数据库文件路径  第二个参数:数据库对象
        
        if sqlite3_open(cDBPath, &db) != SQLITE_OK {
            print("数据库打开失败")
        }
        return creatTable();
    }
    
    //创建表
    func creatTable() -> Bool {
        //建表的SQL语句
        let creatUserTable = "CREATE TABLE IF NOT EXISTS 'RAINBOWTABLE' ( 'ID' INTEGER PRIMARY KEY NOT NULL,'START' TEXT NOT NULL,'END' TEXT NOT NULL);"
        
        //执行SQL语句-创建表 依然,项目中一般不会只有一个表
        return creatTableExecSQL(SQL_ARR: [creatUserTable])
    }
    
    //执行建表SQL语句
    func creatTableExecSQL(SQL_ARR : [String]) -> Bool {
        for item in SQL_ARR {
            if execSQL(SQL: item) == false {
                return false
            }
        }
        return true
    }
    
    // 查询数据库，传入SQL查询语句，返回一个字典数组
    func queryDataBase(querySQL : String) -> String? {
        // 创建一个语句对象
        var statement : OpaquePointer? = nil
        
        if querySQL.lengthOfBytes(using: String.Encoding.utf8) > 0 {
            let cQuerySQL = (querySQL.cString(using: String.Encoding.utf8))!
            // 进行查询前的准备工作
            // 第一个参数：数据库对象，第二个参数：查询语句，第三个参数：查询语句的长度（如果是全部的话就写-1），第四个参数是：句柄（游标对象）
            if sqlite3_prepare_v2(db, cQuerySQL, -1, &statement, nil) == SQLITE_OK {
                var queryData = String()
                while sqlite3_step(statement) == SQLITE_ROW {
                    // 获取解析到的列
                    //let columnCount = sqlite3_column_count(statement)
                    // 遍历某行数据
                    //var temp = [String : AnyObject]()
                    //for i in 0..<columnCount {
                        // 取出i位置列的字段名,作为temp的键key
                        //let cKey = sqlite3_column_name(statement, i)
                        //let key : String = String(validatingUTF8: cKey!)!
                        //取出i位置存储的值,作为字典的值value
                        let cValue = sqlite3_column_text(statement, 0)
                        let value = String(cString: cValue!)
                        queryData = value
                    //}
                    //queryDataArr.append(temp)
                }
                return queryData
            }
        }
        return nil
    }
    
    //执行SQL语句
    func execSQL(SQL : String) -> Bool {
        // 1.将sql语句转成c语言字符串
        let cSQL = SQL.cString(using: String.Encoding.utf8)
        //错误信息
        let errmsg : UnsafeMutablePointer<UnsafeMutablePointer<Int8>?>? = nil
        if sqlite3_exec(db, cSQL, nil, nil, errmsg) == SQLITE_OK {
            return true
        }else{
            print("SQL 语句执行出错 -> 错误信息: 一般是SQL语句写错了 \(String(describing: errmsg))")
            return false
        }
    }
}
