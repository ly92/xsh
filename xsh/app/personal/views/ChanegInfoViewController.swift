//
//  ChanegInfoViewController.swift
//  xsh
//
//  Created by ly on 2018/12/27.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class ChanegInfoViewController: BaseViewController {

    
    var changeType = 1//1:名字，2：身份证号
    var editTextBlock : ((String) -> Void)?
    
    fileprivate let textTF = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = BG_Color
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.changeType == 1{
            self.navigationItem.title = "昵称"
            self.textTF.placeholder = "请输入昵称"
        }else{
            self.navigationItem.title = "身份证"
            self.textTF.placeholder = "请输入身份证号"
        }
        self.textTF.delegate = self
        self.textTF.returnKeyType = .done
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "完成", target: self, action: #selector(ChanegInfoViewController.rightItemAction))
        self.setMainUI()
    }
    
    //设置主页面
    func setMainUI() {
        //view
        let topView = UIView()
        topView.addSubview(self.textTF)
        topView.backgroundColor = UIColor.white
        self.view.addSubview(topView)
        
        topView.snp.makeConstraints { (make) in
            make.top.trailing.leading.equalTo(0)
            make.height.equalTo(50)
        }
        
        self.textTF.snp.makeConstraints { (make) in
            make.leading.equalTo(10)
            make.trailing.equalTo(-10)
            make.center.equalToSuperview()
        }
    }

    
    //完成
    @objc func rightItemAction() {
        self.textTF.resignFirstResponder()
        guard let text = self.textTF.text else {
            LYProgressHUD.showError("请确保输入无误")
            return
        }
        if text.isEmpty{
            LYProgressHUD.showError("不可为空！")
            return
        }
        if self.changeType == 2 && !text.isIdCard(){
            LYProgressHUD.showError("身份证号格式不准确！")
            return
        }
        if self.editTextBlock != nil{
            self.editTextBlock!(text)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

extension ChanegInfoViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textTF.resignFirstResponder()
        return true
    }
}
