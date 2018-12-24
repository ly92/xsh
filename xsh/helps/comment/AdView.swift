//
//  AdView.swift
//  xsh
//
//  Created by ly on 2018/12/24.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class AdView: UIView {

    //
    func setUpSubViews(_ json : JSON) {
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH)
        UIApplication.shared.keyWindow?.addSubview(self)
        UIApplication.shared.keyWindow?.bringSubviewToFront(self)

        //webview
        let webView = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH))
        webView.delegate = self
        webView.scalesPageToFit = true
        
        let content = json["content"].stringValue
        if content.hasPrefix("这里"){
            var url = json["imageurl"].stringValue
            if url.isEmpty{
                url = "http://starlife3c.test.upcdn.net/ads/201812/154544684745.img"
            }
            let request = URLRequest.init(url: URL(string:url)!)
            webView.loadRequest(request)
        }else{
            let html = "<html> <body> " + content + "</body> </html>"
            webView.loadHTMLString(html, baseURL: URL(string:"www.baidu.com"))
        }
        self.addSubview(webView)
        
        
        //跳过btn
        let skipBtn = UIButton(frame:CGRect.init(x: kScreenW - 100, y: 40, width: 80, height: 30))
        skipBtn.backgroundColor = UIColor.RGBSA(s: 0, a: 0.3)
        skipBtn.setTitle("跳过", for: .normal)
        skipBtn.setTitleColor(UIColor.white, for: .normal)
        skipBtn.clipsToBounds = true
        skipBtn.layer.cornerRadius = 5
        skipBtn.addTarget(self, action: #selector(AdView.skipAction), for: .touchDown)
        self.addSubview(skipBtn)
        
        
        self.addTapActionBlock {
            self.skipAction()
            //详情
            //跳转外部链接
            let webVC = BaseWebViewController()
            webVC.titleStr = json["title"].stringValue
            webVC.urlStr = json["imageurl"].stringValue
            guard let nav = AppDelegate.sharedInstance.tabBar.selectedViewController as? LYNavigationController else{
                return
            }
            nav.viewControllers.first?.present(webVC, animated: true) {
            }
        }
        
        webView.addTapActionBlock {
            //详情
            //跳转外部链接
            let webVC = BaseWebViewController()
            webVC.titleStr = json["title"].stringValue
            webVC.urlStr = json["imageurl"].stringValue
            guard let nav = AppDelegate.sharedInstance.tabBar.selectedViewController as? LYNavigationController else{
                return
            }
            nav.viewControllers.first?.present(webVC, animated: true) {
            }
        }
        
        //视图在导航器中显示默认四边距离
        if #available(iOS 11.0, *){
            webView.scrollView.contentInsetAdjustmentBehavior = .never
        }
    }

    //跳过
    @objc func skipAction(){
        self.removeFromSuperview()
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = ((touches as NSSet).anyObject() as AnyObject)     //进行类  型转化
//
//        let point = touch.location(in:self)     //获取当前点击位置
//        if
//
//    }
    
    
    //展示
    class func showWithJson(_ json : JSON){
        AdView().setUpSubViews(json)
    }
    
}



extension AdView : UIWebViewDelegate{
    
}
