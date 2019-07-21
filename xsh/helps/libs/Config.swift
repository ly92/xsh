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
//let KWechatKey = "wx01e4c37152e4b98f"//中燕
let KWechatKey = "wxbff455048a79dd5f"//20190508-ly，北控
//let KWechatKey = "wx14b06ec2e4b5d070"
let KJpushKey = "2423b2f1b952e7e1b8a38be7"
let KBmapKey = "VO4wfMvoSvhxqjmGWmADGgN4zvfrF6sE"
let KBuglyKey = "b736017019"

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

//功能栏点击
func globalFunctionClickAction(_ json : JSON, _ vc : UIViewController){
    
    //统计点击
    DispatchQueue.global().async {
        var params : [String : Any] = [:]
        params["platform"] = "ios"
        params["access_log_type_id"] = json["access_log_type_id"].stringValue
        NetTools.requestData(type: .post, urlString: ClickFuncStatisticsApi, parameters: params, succeed: { (result) in
        }, failure: { (error) in
        })
        
    }
    
    if json["actiontype"].intValue == 0{
        //跳转外部链接
        let ts = Date.phpTimestamp()
        let cmdno = String.randomStr(len: 20) + ts
        let sign = (LocalData.getCId() + ts + cmdno + LocalData.getPwd()).md5String()
        let webVC = BaseWebViewController()
        webVC.titleStr = json["name"].stringValue
        let url = json["actionurl"].stringValue.replacingOccurrences(of: "$cid$", with: LocalData.getCId()).replacingOccurrences(of: "$ts$", with: ts).replacingOccurrences(of: "$sign$", with: sign).replacingOccurrences(of: "$cmdno$", with: cmdno)
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
        }else if json["actionios"].stringValue == "ComplaintController"{
            let complantVC = ComplaintViewController.spwan()
            vc.navigationController?.pushViewController(complantVC, animated: true)
        }else if json["actionios"].stringValue == "RepairController"{
            let repairVC = RepairViewController.spwan()
            vc.navigationController?.pushViewController(repairVC, animated: true)
        }else if json["actionios"].stringValue == "MotionViewController"{
            let motionVC = MotionViewController.spwan()
            vc.navigationController?.pushViewController(motionVC, animated: true)
        }
        
    }else if json["actiontype"].intValue == 2{
        //第三方应用
        
    }else if json["actiontype"].intValue == 3{
        //保留
        
    }else if json["actiontype"].intValue == 4{
        //详情页
        
    }
    
}

//首页广告点击效果
func globalAdClickAction(_ json : JSON, _ vc : UIViewController){
    if json["actiontype"].intValue == 0{
        //跳转外部链接
        let webVC = BaseWebViewController()
        webVC.titleStr = json["title"].stringValue
        let url = json["outerurl"].stringValue
        webVC.urlStr = url
        vc.navigationController?.pushViewController(webVC, animated: true)
        
        DispatchQueue.global().async {
            let params : [String : Any] = ["id":json["id"].stringValue]
            NetTools.requestData(type: .post, urlString: AdDetailApi, parameters: params, succeed: { (result) in
            }) { (error) in
            }
        }
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
        let webVC = BaseWebViewController()
        webVC.isFromAd = true
        webVC.titleStr = json["title"].stringValue
        webVC.adId = json["id"].stringValue
        vc.navigationController?.pushViewController(webVC, animated: true)
    }
    
}




class Config: NSObject {
    
}
