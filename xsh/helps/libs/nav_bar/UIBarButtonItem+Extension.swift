//
//  UIBarButtonItem+Extension.swift
//  qixiaofu
//
//  Created by ly on 2017/6/19.
//  Copyright © 2017年 qixiaofu. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    
    convenience init(title:String,target:Any?,action:Selector){
        let btn = UIButton(type:.custom)
        btn.addTarget(target, action: action, for: .touchUpInside)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(UIColor(red: 33 / 255.0, green: 33 / 255.0, blue: 33 / 255.0, alpha: 1.0), for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        btn.sizeToFit()
//        if #available(iOS 11.0, *) {
//            btn.frame = CGRect.init(x: 0, y: 0, width: btn.w, height: 44)
//            btn.contentEdgeInsets = UIEdgeInsetsMake(5, 0, -5, 0)
//        }

        self.init(customView: btn)
    }
    
    convenience init(image:UIImage?,target:Any?,action:Selector){
        let btn = UIButton(type:.custom)
        btn.addTarget(target, action: action, for: .touchUpInside)
        if image != nil{
            btn.setImage(image, for: .normal)
        }else{
            btn.setTitle("按钮", for: .normal)
        }
        btn.imageView?.contentMode = .scaleAspectFit
//        btn.sizeToFit()
        btn.size = CGSize.init(width: 35, height: 50)
//        if #available(iOS 11.0, *) {
//            btn.frame = CGRect.init(x: 0, y: 0, width: btn.w, height: 44)
//            btn.contentEdgeInsets = UIEdgeInsetsMake(5,0 , -5, 0)
//        }
        self.init(customView: btn)
    }
    
    convenience init(backTarget:Any?,action:Selector) {
        let btn = UIButton(type:.custom)
        btn.addTarget(backTarget, action: action, for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        
        btn.imageView?.contentMode = .scaleAspectFit
        btn.contentHorizontalAlignment = .left
        btn.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: 10, bottom: 0, right: 0)
        btn.size = CGSize.init(width: 50, height: 50)
        self.init(customView: btn)
    }

}
