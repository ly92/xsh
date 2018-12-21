//
//  Config.swift
//  xsh
//
//  Created by ly on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit


//屏幕尺寸
let kScreenSize = UIScreen.main.bounds.size
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height


let NAV_Color = UIColor.white
let Text_Color = UIColor.RGBS(s: 33)
let BG_Color = UIColor.RGBS(s: 240)
let Normal_Color = UIColor.RGB(r: 205, g: 56, b: 37)

//版本号
func appVersion() -> String {
    let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    return currentVersion
}

//是否允许消息通知
func isMessageNotificationServiceOpen() -> Bool{
    return UIApplication.shared.isRegisteredForRemoteNotifications
}





class Config: NSObject {
    
}