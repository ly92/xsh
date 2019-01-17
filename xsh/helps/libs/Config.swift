//
//  Config.swift
//  xsh
//
//  Created by ly on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON


//屏幕尺寸
let kScreenSize = UIScreen.main.bounds.size
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height


let KWechatPayNotiName = "WechatPayResultNotificationName"
let KLoginSuccessNotiName = "KLoginSuccessNotiName"



let KAliPayScheme = "alipayappyssh111"
let KWechatKey = "wx01e4c37152e4b98f"

let KBmapKey = "VO4wfMvoSvhxqjmGWmADGgN4zvfrF6sE"


let NAV_Color = UIColor.white
let Text_Color = UIColor.RGBS(s: 33)
let BG_Color = UIColor.RGBS(s: 240)
let Normal_Color = UIColor.RGB(r: 73, g: 205, b: 170)

//版本号
func appVersion() -> String {
    let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
    return currentVersion
}


//是否允许消息通知
func isMessageNotificationServiceOpen() -> Bool{
    return UIApplication.shared.isRegisteredForRemoteNotifications
}


func globalFunctionClickAction(_ json : JSON, _ vc : UIViewController){
    if json["actiontype"].intValue == 0{
        //跳转外部链接
        let webVC = BaseWebViewController()
        webVC.titleStr = json["name"].stringValue
        let url = json["actionurl"].stringValue.replacingOccurrences(of: "$cid$", with: LocalData.getCId())
        print(url)
        webVC.urlStr = url
        vc.navigationController?.pushViewController(webVC, animated: true)
    }else if json["actiontype"].intValue == 1{
        //跳转内部页面
        if json["actionios"].stringValue == "NoticeViewController"{
            let noticeVC = NoticeTableViewController()
            vc.navigationController?.pushViewController(noticeVC, animated: true)
        }else if json["actionios"].stringValue == "MoreViewController"{
            let moreFuncVC = MoreFunctionViewController()
            vc.navigationController?.pushViewController(moreFuncVC, animated: true)
        }else if json["actionios"].stringValue == "CouponViewController"{
            let couponVC = CouponViewController()
            vc.navigationController?.pushViewController(couponVC, animated: true)
        }
        
    }else if json["actiontype"].intValue == 2{
        //第三方应用
        
    }else if json["actiontype"].intValue == 3{
        //保留
        
    }else if json["actiontype"].intValue == 4{
        //详情页
        
    }
    
}




class Config: NSObject {
    
}
