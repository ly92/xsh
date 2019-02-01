//
//  LocalData.swift
//  qixiaofu
//   _
//  | |      /\   /\
//  | |      \ \_/ /
//  | |       \_~_/
//  | |        / \
//  | |__/\    [ ]
//  |_|__,/    \_/
//
//  Created by 李勇 on 2017/5/30.
//  Copyright © 2017年 qixiaofu. All rights reserved.
//
//  __________________________________________________
// |                    _                             |
// | /|,/ _   _ _      / ` /_  _ .  _ _/_ _ _   _    _|
// |/  / /_' / / /_/  /_, / / / / _\  /  / / / /_| _\ |
// |             _/                                   |
// |                 ~~** liwu19 **~~                 |
// |__________________________________________________|
//
//
//                       ___
//                    /`   `'.
//                   /   _..---;
//                   |  /__..._/  .--.-.
//                   |.'  e e | ___\_|/____
//                  (_)'--.o.--|    | |    |
//                 .-( `-' = `-|____| |____|
//                /  (         |____   ____|
//                |   (        |_   | |  __|
//                |    '-.--';/'/__ | | (  `|
//                |      '.   \    )"";--`\ /
//                \        ;   |--'    `;.-'
//                |`-.__ ..-'--'`;..--'`
//
// :*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*:._.:*~*
//
import UIKit
import SwiftyJSON


let KUserIdKey = "KUserIdKey"
let KUserPwdKey = "KUserPwdKey"
let KUserTruePwdKey = "KUserTruePwdKey"
let KUserPhoneKey = "KUserPhoneKey"
let KIsLoginKey = "KLogin" + LocalData.getUserPhone()


class LocalData: NSObject {

    // MARK: - UserDefaults
    
    // MARK: - base
    // 删除UserDefaults记录的所有数据
    class func removeAllLocalData(){
        guard let appDomain = Bundle.main.bundleIdentifier else {return}
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
    }
    //通过key删除数据
    class func removeLocalData(key: String){
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    
    
    // MARK: - 获取User phone
    class func saveUserPhone(phone: String){
        UserDefaults.standard.setValue(phone, forKey: KUserPhoneKey)
        UserDefaults.standard.synchronize()
    }
    class func getUserPhone() -> String{
        let phone = UserDefaults.standard.value(forKey:KUserPhoneKey)
        if (phone == nil){
            return ""
        }else{
            return phone as! String
        }
    }
    
    // MARK: - 获取密码
    class func savePwd(pwd: String){
        UserDefaults.standard.setValue(pwd, forKey: KUserPwdKey)
        UserDefaults.standard.synchronize()
    }
    class func getPwd() -> String{
        let pwd = UserDefaults.standard.value(forKey:KUserPwdKey)
        if (pwd == nil){
            return ""
        }else{
            return pwd as! String
        }
    }
    
    
    // MARK: - 获取明文密码
    class func saveTruePwd(pwd: String){
        UserDefaults.standard.setValue(pwd, forKey: KUserTruePwdKey)
        UserDefaults.standard.synchronize()
    }
    class func getTruePwd() -> String{
        let pwd = UserDefaults.standard.value(forKey:KUserTruePwdKey)
        if (pwd == nil){
            return ""
        }else{
            return pwd as! String
        }
    }
    
    
    // MARK: - 获取cid
    class func saveCId(cid: String){
        UserDefaults.standard.setValue(cid, forKey: KUserIdKey)
        UserDefaults.standard.synchronize()
    }
    class func getCId() -> String{
        let cid = UserDefaults.standard.value(forKey:KUserIdKey)
        if (cid == nil){
            return ""
        }else{
            return cid as! String
        }
    }
    
    
    // MARK: - 获取 device token
    class func saveToken(token: String){
        UserDefaults.standard.setValue(token, forKey: "KDeviceToken")
        UserDefaults.standard.synchronize()
    }
    class func getToken() -> String{
        let token = UserDefaults.standard.value(forKey : "KDeviceToken")
        if (token == nil){
            return "------temp--------temp-----"
        }else{
            return token as! String
        }
    }
    
    // MARK: - 获取存储数据的bool值,1为Yes,0为No
    class func saveYesOrNotValue(value: String, key: String){
        //对记录登录特殊处理
        UserDefaults.standard.setValue(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func getYesOrNotValue(key: String) -> Bool{
        let value = UserDefaults.standard.value(forKey:key)
        if (value == nil || value as! String == "0"){
            return false
        }else{
            return true
        }
    }
    
    
    // MARK: - 广告地址
    class func saveAdJson(json: JSON){
        UserDefaults.standard.setValue(json.description, forKey: "KAdJson")
        UserDefaults.standard.synchronize()
    }
    class func getAdJson() -> JSON{
        let jsonStr = UserDefaults.standard.value(forKey : "KAdJson")
        if (jsonStr == nil){
            return JSON()
        }else{
            let json = JSON.init(parseJSON: jsonStr! as! String)
            return json
        }
    }
    
    
}



