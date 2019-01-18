//
//  LYTabBar.swift
//  xsh
//
//  Created by 李勇 on 2018/12/12.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

protocol LYTabBarDelegate {
    func clickAction(tabbar : LYTabBar)
}


class LYTabBar: UITabBar {
    var lyTabBarDelegate : LYTabBarDelegate?
    let btn = UIButton()
    let lbl = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func addButton() {
        btn.setBackgroundImage(UIImage.init(named: "tabbar_scan"), for: .normal)
//        btn.setBackgroundImage(UIImage.init(named: "qrcodescan-2"), for: .highlighted)
        
        btn.addTarget(self, action: #selector(LYTabBar.btnAction), for: .touchUpInside)
        self.addSubview(btn)
    }
    
    
    @objc func btnAction() {
        self.lyTabBarDelegate?.clickAction(tabbar: self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
        self.btn.center_x = self.center_x
        self.btn.center_y = self.h * 0.5 - 10
        
        self.btn.size = self.btn.currentBackgroundImage?.size
        
//        self.lbl.text = "哈哈"
//        self.lbl.font = UIFont.systemFont(ofSize: 10)
//        self.lbl.textColor = UIColor.gray
//        self.lbl.sizeToFit()
//        self.lbl.center_x = self.btn.center_x
//        self.lbl.center_y = self.btn.frame.maxY + 0.5 * 10 + 0.5
//        self.addSubview(self.lbl)
        
        var index = 0
        for view in self.subviews{
            
            let UITabBarButton = NSClassFromString("UITabBarButton") ?? UITabBarItem.self
            
            if view.isKind(of: UIImageView.self) && view.h < 1{
                view.isHidden = true
            }else if view.isKind(of: UITabBarButton){
                view.w = self.w / 5.0
                view.x = view.w * CGFloat(index)
                index += 1
                if index == 2{
                    index += 1
                }
            }
            self.bringSubviewToFront(view)
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden{
            return super.hitTest(point, with: event)
        }else{
            let btnPoint = self.convert(point, to: self.btn)
            let lblPoint = self.convert(point, to: self.lbl)
            
            if self.btn.point(inside: btnPoint, with: event){
                return self.btn
            }else if self.lbl.point(inside: lblPoint, with: event){
                return self.btn
            }else{
                return super.hitTest(point, with: event)
            }
        }
    }
    
    
}
