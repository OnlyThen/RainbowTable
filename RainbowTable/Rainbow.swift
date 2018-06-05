//
//  Rainbow.swift
//  RainbowTable
//
//  Created by 张瑜 on 2018/5/5.
//  Copyright © 2018年 张瑜. All rights reserved.
//
/*
 This class design three functions.
 */
import Foundation

class Rainbow: NSObject {
    
    static let instance = Rainbow()
    class func shareInstance() -> Rainbow {
        return instance
    }
    
    let charSet: String = "0123456789abcdefghijklmnopqrstuvwxyz"
    //var db : OpaquePointer? = nil
    
    func generateChain(lengthOfChain: Int, lengthOfString: Int, id: Int) -> Chain {
        let start = generateStartStr(lengthOfString: lengthOfString, count: charSet.count)
        var temp: String = start.md5()
        var end: String = ""
        for index in 0 ..< lengthOfChain {
            end = reduce(hash: temp, step: index, lengthOfString: lengthOfString, count: charSet.count, seedOfReduce: 0)
            temp = end.md5()
        }
        let chain = Chain(id: id, start: start, end: end)
        return chain
    }
    
    func generateStartStr(lengthOfString: Int, count: Int) -> String {
        var string = ""
        for _ in 0 ..< lengthOfString {
            let index = Int(arc4random_uniform(UInt32(count)))
            string.append(charSet[charSet.index(charSet.startIndex, offsetBy: index)])
        }
        
        return string
    }
    
    func reduce(hash: String, step: Int, lengthOfString: Int, count: Int, seedOfReduce: Int) -> String {
        var string = ""
        var s = step
        for k in 0 ..< lengthOfString {
            let index = (String.changeToInt(num: String(hash.prefix(5+k))) ^ s) % count
            string.append(charSet[charSet.index(charSet.startIndex, offsetBy: index)])
            s = s + 1
        }
        return string
    }

}

