//
//  MD5String.swift
//  RainbowTable
//
//  Created by 张瑜 on 2018/5/5.
//  Copyright © 2018年 张瑜. All rights reserved.
//
/*
 Extension of String. you will know what this function can do by it's name.
 */
import Foundation

extension String {
    
    func md5() -> String {
        let string = self.cString(using: String.Encoding.utf8)
        let strLength = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        
        CC_MD5(string!, strLength, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLength {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        
        return String(format: hash as String)
    }
    
    static func changeToInt(num: String) -> Int {
        let str = num.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    
    func getSubString(start: Int, end: Int) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex   = self.index(self.endIndex, offsetBy: end)
        return String(self[startIndex ..< endIndex])
    }
    
}
