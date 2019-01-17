//
//  ChangePhoneViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/1/15.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit

class ChangePhoneViewController: UITableViewController {
    class func spwan() -> ChangePhoneViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! ChangePhoneViewController
    }
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var sureBtn: UIButton!
    
    fileprivate var timer = Timer()//
    fileprivate var codeTime : Int = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "修改手机号"
        self.sureBtn.layer.cornerRadius = 25
    }

    
    
    
    @IBAction func sureAction() {
        self.view.endEditing(true)
        
        guard let phone = self.phoneTF.text else {
            LYProgressHUD.showError("请输入手机号")
            return
        }
        guard let code = self.codeTF.text else {
            LYProgressHUD.showError("请输入验证码")
            return
        }
        guard let pwd = self.pwdTF.text else {
            LYProgressHUD.showError("请输入登录密码")
            return
        }
        if !phone.isMobelPhone(){
            LYProgressHUD.showError("请输入手机号")
            return
        }
        if code.isEmpty{
            LYProgressHUD.showError("请输入验证码")
            return
        }
        if pwd.isEmpty{
            LYProgressHUD.showError("请输入支付密码")
            return
        }
        
        var params : [String : Any] = [:]
        params["mobile"] = phone
        params["code"] = code
        params["passwd"] = (pwd.md5String() + LocalData.getUserPhone()).md5String()
        NetTools.requestData(type: .post, urlString: ChangePhoneApi, parameters: params, succeed: { (result) in
            LocalData.saveUserPhone(phone: phone)
            LYProgressHUD.showSuccess("修改成功，请重新登录！")
            self.navigationController?.popToRootViewController(animated: true)
//            let loginVC = LoginViewController.spwan()
//            self.present(loginVC, animated: true) {
//            }
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    @IBAction func codeAction() {
        guard let phone = self.phoneTF.text else {
            LYProgressHUD.showError("请输入手机号")
            return
        }
        if !phone.isMobelPhone(){
            LYProgressHUD.showError("请输入手机号")
            return
        }
        
        var params : [String : Any] = [:]
        params["mobile"] = phone
        NetTools.normalRequest(type: .post, urlString: GetCodeApi, parameters: params, succeed: { (result) in
            self.setUpCodeTimer()
            self.codeTF.becomeFirstResponder()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    func setUpCodeTimer() {
        self.codeTime = 60
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in
            if self.codeTime > 0{
                
                self.codeBtn.isEnabled = false
                self.codeBtn.setTitle("\(self.codeTime) 秒后重新获取", for: .disabled)
                self.codeTime -= 1
            }else{
                self.codeBtn.isEnabled = true
                self.codeBtn.setTitle("重新获取", for: .normal)
                
                timer.invalidate()
            }
        }
    }
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }

}
