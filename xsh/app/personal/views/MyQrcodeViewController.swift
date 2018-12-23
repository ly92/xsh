//
//  MyQrcodeViewController.swift
//  xsh
//
//  Created by ly on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SnapKit

class MyQrcodeViewController: BaseViewController {
    class func spwan() -> MyQrcodeViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! MyQrcodeViewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的优惠券"
    
        self.setUpUI()
    }
    
    func setUpUI() {
        //1、页面背景
        self.view.backgroundColor = UIColor.RGBS(s: 240)
        //2、白色背景
        let bg = UIView()
        bg.backgroundColor = UIColor.white
        self.view.addSubview(bg)
        //3、标题
        let lbl = UILabel()
        lbl.text = "扫描二维码"
        lbl.font = UIFont.systemFont(ofSize: 14.0)
        lbl.textColor = UIColor.RGBS(s: 33)
        bg.addSubview(lbl)
        //4、二维码图片
        let imgV = UIImageView()
        bg.addSubview(imgV)
        imgV.image = UIImageView.createQrcode("1234567890-")
        
        //布局
        bg.snp.makeConstraints { (make) in
            make.top.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(kScreenW)
        }
        
        lbl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(30)
        }
        
        imgV.snp.makeConstraints { (make) in
            make.top.equalTo(lbl.snp.bottom).offset(10)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(kScreenW-70)
//            make.center.equalToSuperview()
//            make.width.height.equalTo(kScreenW-70)
        }
    }
    

}
