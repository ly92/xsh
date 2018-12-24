//
//  PayPasswordView.swift
//  xsh
//
//  Created by 李勇 on 2018/12/24.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
typealias PayPasswordViewBlock = (String) -> Void


class PayPasswordView: UIView {
    
    var payTextBlock : PayPasswordViewBlock?
    var sourceArray : Array<UITextField> = Array<UITextField>()
    var mainTextTF : UITextField = UITextField()
    var parentVC = UIViewController()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
    
    func setUpSubViews() {
        //1.背景图
        self.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH)
        UIApplication.shared.keyWindow?.addSubview(self)
        UIApplication.shared.keyWindow?.bringSubviewToFront(self)
        self.addTapActionBlock {
            self.cancelAction()
        }
        self.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        //2.支付框
        let boxView = UIView(frame:CGRect.init(x: (kScreenW - 300)/2.0, y: 150, width: 300, height: 180))
        boxView.backgroundColor = UIColor.white
        boxView.clipsToBounds = true
        boxView.layer.cornerRadius = 10
        self.addSubview(boxView)
        
        //3.支付提示
        let payLbl = UILabel(frame:CGRect.init(x: 0, y: 0, width: 300, height: 30))
        payLbl.textAlignment = .center
        payLbl.textColor = UIColor.RGBS(s: 33)
        payLbl.text = "请输入支付密码"
        boxView.addSubview(payLbl)
        
        //3.输入框
        
        let pwdView = UIView(frame:CGRect.init(x: 25, y: 55, width: 250, height: 50))
        pwdView.backgroundColor = UIColor.clear
        boxView.addSubview(pwdView)
        
        let margin : CGFloat = 8
        let width : CGFloat = 35
        
        for i in 0...5 {
            let textTF = UITextField()
            textTF.tag = i
            textTF.isEnabled = false
            textTF.isSecureTextEntry = true
            textTF.backgroundColor = UIColor.white
            textTF.keyboardType = .numberPad
            textTF.textAlignment = .center
            textTF.borderStyle = .none
            textTF.layer.borderColor = UIColor.RGBS(s: 150).cgColor
            textTF.layer.borderWidth = 1 / UIScreen.main.scale
            textTF.frame = CGRect.init(x: CGFloat(i) * (width + margin), y: 0, width: width, height: width)
            pwdView.addSubview(textTF)
            sourceArray.append(textTF)
        }
        
        mainTextTF.frame = pwdView.frame
        mainTextTF.textColor = UIColor.clear
        mainTextTF.delegate = self
        mainTextTF.borderStyle = .none
        mainTextTF.keyboardType = .numberPad
        mainTextTF.tintColor = UIColor.clear
        mainTextTF.becomeFirstResponder()
        boxView.addSubview(mainTextTF)
        
        //4.忘记支付密码
        let forgetPayPwdBtn = UIButton(frame:CGRect.init(x: 0, y: 180 - 80, width: 300, height: 30))
        forgetPayPwdBtn.setTitle("忘记支付密码", for: .normal)
        forgetPayPwdBtn.setTitleColor(UIColor.RGB(r: 0, g: 122, b: 255), for: .normal)
        forgetPayPwdBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        forgetPayPwdBtn.addTarget(self, action: #selector(PayPasswordView.forgetPayPwdAction), for: .touchUpInside)
        boxView.addSubview(forgetPayPwdBtn)
        
        //5.取消按钮
        let cancelBtn = UIButton(frame:CGRect.init(x: 0, y: 180 - 44, width: 150, height: 44))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        cancelBtn.backgroundColor = UIColor.gray
        cancelBtn.addTarget(self, action: #selector(PayPasswordView.cancelAction), for: .touchUpInside)
        boxView.addSubview(cancelBtn)
        
        //6.确定按钮
        let sureBtn = UIButton(frame:CGRect.init(x: 150, y: 180 - 44, width: 150, height: 44))
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.backgroundColor = Normal_Color
        sureBtn.addTarget(self, action: #selector(PayPasswordView.sureAction), for: .touchUpInside)
        boxView.addSubview(sureBtn)
    }
    
    func show(textBlock:PayPasswordViewBlock?) {
        payTextBlock = textBlock
        self.setUpSubViews()
    }
    
    @objc func sureAction() {
        if (payTextBlock != nil){
            if mainTextTF.text?.count == 6{
                payTextBlock!(mainTextTF.text!)
                self.removeFromSuperview()
            }else{
                LYProgressHUD.showError("密码必须为6位数字!")
            }
        }
    }
    
    @objc func cancelAction() {
        self.removeFromSuperview()
    }
    
    //忘记原支付密码
    @objc func forgetPayPwdAction() {
        self.removeFromSuperview()
        //修改密码
        let changePwdVC = ChangeCardPwdViewController.spwan()
        self.parentVC.navigationController?.pushViewController(changePwdVC, animated: true)
    }
}

extension PayPasswordView : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 0{
            //增加字符
            if (textField.text?.count)! > 5{
                LYProgressHUD.showError("最多6位数字！")
                return false
            }else{
                let TF = sourceArray[(textField.text?.count)!]
                TF.text = string
            }
        }else{
            //删除字符
            let TF = sourceArray[(textField.text?.count)! - 1]
            TF.text = ""
        }
        return true
    }
}

