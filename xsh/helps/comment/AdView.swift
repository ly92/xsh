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
    
    fileprivate var imgV = UIImageView()
    fileprivate var adArray : Array<JSON> = []
    fileprivate var index : Int = 0
    
    //
    func setUpSubViews(_ jsonArr : JSON) {
        
        self.adArray = jsonArr.arrayValue
        
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH)
        UIApplication.shared.keyWindow?.addSubview(self)
        UIApplication.shared.keyWindow?.bringSubviewToFront(self)
        
        //imageview
        self.imgV.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH)
        self.addSubview(self.imgV)
        
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
            
            let json = self.adArray[self.index - 1]
            
            //跳转外部链接
            let webVC = BaseWebViewController()
            webVC.titleStr = json["title"].stringValue
            webVC.urlStr = json["outerurl"].stringValue
            guard let nav = AppDelegate.sharedInstance.tabBar.selectedViewController as? LYNavigationController else{
                return
            }
            if LocalData.getYesOrNotValue(key: KIsLoginKey){
                nav.viewControllers.first?.navigationController?.pushViewController(webVC, animated: true)
            }else{
                webVC.isPresent = true
                let nav_webVC = LYNavigationController.init(rootViewController: webVC)
                nav.viewControllers.first?.presentedViewController?.present(nav_webVC, animated: true, completion: {
                })
            }
        }
        
        self.showImage()
        
    }
    
    
    func showImage() {
        let json = self.adArray[self.index]
        var url = json["imageurl"].stringValue
        if url.isEmpty{
            url = "http://starlife3c.test.upcdn.net/ads/201812/154544684745.img"
        }
        self.imgV.setImageUrlStrAndPlaceholderImg(url, #imageLiteral(resourceName: "ad_placeholder"))
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            if self.adArray.count > self.index{
                self.showImage()
            }else{
                self.skipAction()
            }
        }
        self.index += 1
    }
    

    //跳过
    @objc func skipAction(){
        UIView.animate(withDuration: 2, animations: {
            self.alpha = 0.3
        }) { (comp) in
            self.removeFromSuperview()
        }
    }
    
    
    //展示
    class func showWithJson(_ json : JSON){
        AdView().setUpSubViews(json)
    }
    
}

