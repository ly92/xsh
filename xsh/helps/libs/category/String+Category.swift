//
//  String+Category.swift
//  qixiaofu
//
//  Created by 李勇 on 2017/6/7.
//  Copyright © 2017年 qixiaofu. All rights reserved.
//

import Foundation
import UIKit

//
extension String{
    
    //手机号识别
    func isMobelPhone() -> Bool {
        if self.count != 11{
            return false
        }
        
        let MOBILE = "^1(3[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$"
        let CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        
        let regrxtestMobile = NSPredicate(format: "SELF MATCHES %@", MOBILE)
        let regrxtestCm = NSPredicate(format: "SELF MATCHES %@", CM)
        let regrxtestCu = NSPredicate(format: "SELF MATCHES %@", CU)
        let regrxtestCt = NSPredicate(format: "SELF MATCHES %@", CT)
        
        return regrxtestMobile.evaluate(with:self) || regrxtestCm.evaluate(with:self) || regrxtestCu.evaluate(with:self) || regrxtestCt.evaluate(with:self)
    }
    
    //身份证识别
    func isIdCard() -> Bool {
        if self.count != 18{
            return false
        }
        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X|x)$)"
        let regrxtest = NSPredicate(format:"SELF MATCHES %@",pattern)
        return regrxtest.evaluate(with: self)
    }
    
    func sizeFit(width:CGFloat,height:CGFloat,fontSize:CGFloat) -> CGSize {
        let lbl = UILabel()
        lbl.text = self
        lbl.font = UIFont.systemFont(ofSize: fontSize)
        lbl.numberOfLines = 0
        return lbl.sizeThatFits(CGSize.init(width: width, height: height))
    }
    
    func sizeFitTextView(width:CGFloat,height:CGFloat,fontSize:CGFloat) -> CGSize {
        let textView = UITextView()
        textView.text = self
        textView.font = UIFont.systemFont(ofSize: fontSize)
        return textView.sizeThatFits(CGSize.init(width: width, height: height))
    }
    
    
    static func randomStr(len : Int) -> String{
        let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    
}

// MARK: - MD5
extension String{
    func md5String() -> String{
        let cStr = self.cString(using: String.Encoding.utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString();
        for i in 0 ..< 16{
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
    
//    var md5: String! {
//        let str = self.cString(using: String.Encoding.utf8)
//        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
//        CC_MD5(str!, strLen, result)
//        return stringFromBytes(bytes: result, length: digestLen)
//    }
    
    func stringFromBytes(bytes: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String{
        let hash = NSMutableString()
        for i in 0..<length {
            hash.appendFormat("%02x", bytes[i])
        }
        bytes.deallocate(capacity: length)
        return String(format: hash as String)
    }
    
}

//MARK: - 数值
extension String{
    
    var trim : String{
        var str = self
        if str.isEmpty{
            return ""
        }
        str = str.trimmingCharacters(in: .whitespacesAndNewlines)
        return str
    }
    
    var floatValue : Float {
        var str = self
        if str.isEmpty{
            return 0
        }
        str = str.trimmingCharacters(in: .whitespacesAndNewlines)
        if str.hasPrefix("-"){
            str.remove(at: str.startIndex)
            let pattern = "^[0-9]\\d*?\\.?[0-9]*?"
            let regrxtest = NSPredicate(format:"SELF MATCHES %@",pattern)
            if regrxtest.evaluate(with: str){
                return -Float(str)!
            }
        }else{
            let pattern = "^[0-9]\\d*?\\.?[0-9]*?"
            let regrxtest = NSPredicate(format:"SELF MATCHES %@",pattern)
            if regrxtest.evaluate(with: str){
                return Float(str)!
            }
        }
        return 0
    }
    
    var intValue : Int {
        var str = self
        if str.isEmpty{
            return 0
        }
        str = str.trimmingCharacters(in: .whitespacesAndNewlines)
        if str.contains("."){
            let array = str.components(separatedBy: ".")
            str = array[0]
        }
        if str.hasPrefix("-"){
            str.remove(at: str.startIndex)
            let pattern = "^[0-9]\\d*?"
            let regrxtest = NSPredicate(format:"SELF MATCHES %@",pattern)
            if regrxtest.evaluate(with: str){
                return -Int(str)!
            }
        }else{
            let pattern = "^[0-9]\\d*?"
            let regrxtest = NSPredicate(format:"SELF MATCHES %@",pattern)
            if regrxtest.evaluate(with: str){
                return Int(str)!
            }
        }
        return 0
    }
    
    var doubleValue : Double {
        var str = self
        if str.isEmpty{
            return 0
        }
        str = str.trimmingCharacters(in: .whitespacesAndNewlines)
        if str.hasPrefix("-"){
            str.remove(at: str.startIndex)
            let pattern = "^[0-9]\\d*?\\.?[0-9]*?"
            let regrxtest = NSPredicate(format:"SELF MATCHES %@",pattern)
            if regrxtest.evaluate(with: str){
                return -Double(str)!
            }
        }else{
            let pattern = "^[0-9]\\d*?\\.?[0-9]*?"
            let regrxtest = NSPredicate(format:"SELF MATCHES %@",pattern)
            if regrxtest.evaluate(with: str){
                return Double(str)!
            }
        }
        return 0
    }
    
    
}
