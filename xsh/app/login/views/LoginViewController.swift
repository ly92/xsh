//
//  LoginViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/15.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class LoginViewController: BaseTableViewController {
    class func spwan() -> LoginViewController{
        return self.loadFromStoryBoard(storyBoard: "Login") as! LoginViewController
    }
    
    @IBOutlet weak var loginPhoneTF: UITextField!
    @IBOutlet weak var changePhoneBtn: UIButton!
    @IBOutlet weak var loginPwdTF: UITextField!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var resetPwdPhoneLbl: UILabel!
    @IBOutlet weak var newPwdTF: UITextField!
    @IBOutlet weak var reNewPwdTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var resetBtn: UIButton!
    

    fileprivate var secIndex = 0//0:手机号登录，1:忘记密码，2:更改密码
    fileprivate var timer = Timer()//
    fileprivate var codeTime : Int = 60
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginBtn.layer.cornerRadius = 25
        self.nextBtn.layer.cornerRadius = 25
        self.resetBtn.layer.cornerRadius = 25
        
        self.loginPhoneTF.text = LocalData.getUserPhone()
        if LocalData.getUserPhone().isMobelPhone(){
            self.changePhoneBtn.isHidden = false
        }
    }

    
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn.tag {
        case 11:
            //切换手机号
            self.loginPhoneTF.text = ""
        case 22:
        //登录
            self.loginAction()
        case 33:
            //忘记密码
            self.getCodeAction(1)
        case 44:
        //去注册
            let registerVC = RegisterViewController.spwan()
            self.present(registerVC, animated: true) {
            }
        case 55:
            //点击忘记密码后的返回
            self.secIndex = 0
            self.tableView.reloadData()
        case 66:
            //获取验证码
            self.getCodeAction(2)
        case 77:
            //去设置新密码
            guard let code = self.codeTF.text else{
                LYProgressHUD.showError("请输入验证码")
                return
            }
            if code.isEmpty{
                LYProgressHUD.showError("请输入验证码")
                return
            }else{
                self.secIndex = 2
                self.tableView.reloadData()
                self.resetPwdPhoneLbl.text = "账号" + self.loginPhoneTF.text!
            }
        case 88:
            //设置新密码的返回
            self.secIndex = 1
            self.tableView.reloadData()
        case 99:
            //确认设置新密码
            self.resetPwdAction()
        default:
            print("bug")
        }
    }
    
    
    //登录
    func loginAction() {
        guard let phone = self.loginPhoneTF.text else {
            return
        }
        guard let pwd = self.loginPwdTF.text else {
            return
        }
        if !phone.isMobelPhone(){
            LYProgressHUD.showError("请输入正确手机号")
            return
        }
        
        var params : [String : Any] = [:]
        params["mobile"] = phone
        params["device"] = LocalData.getToken()
        params["platform"] = "ios"
        params["ts"] = Date.phpTimestamp()
        params["sign"] = (phone + Date.phpTimestamp() + (pwd.md5String() + phone).md5String()).md5String()
        NetTools.normalRequest(type: .post, urlString: LoginApi, parameters: params, succeed: { (result) in
            LocalData.saveUserPhone(phone: phone)
            LocalData.savePwd(pwd: (pwd.md5String() + phone).md5String())
            LocalData.saveCId(cid: result["user"]["cid"].stringValue)
            LocalData.saveYesOrNotValue(value: "1", key: KIsLoginKey)
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    //获取验证码
    func getCodeAction(_ type : Int) {
        guard let phone = self.loginPhoneTF.text else {
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
            if type == 1{
                self.secIndex = 1
                self.tableView.reloadData()
            }
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
    
    
    //重置密码
    func resetPwdAction() {
        guard let pwd = self.newPwdTF.text else {
            LYProgressHUD.showError("请输入密码")
            return
        }
        guard let pwd2 = self.reNewPwdTF.text else {
            LYProgressHUD.showError("请再次输入密码")
            return
        }
        if pwd != pwd2 || pwd.isEmpty || pwd2.isEmpty || pwd.count < 6{
            LYProgressHUD.showError("请确保密码最少6位且两次输入相同")
            return
        }
        guard let phone = self.loginPhoneTF.text else {
            return
        }
        guard let code = self.codeTF.text else {
            return
        }
        
        var params : [String : Any] = [:]
        params["mobile"] = phone
        params["passwd"] = (pwd.md5String() + phone).md5String()
        params["code"] = code
        NetTools.normalRequest(type: .post, urlString: ForgetPwdApi, parameters: params, succeed: { (result) in
            self.secIndex = 0
            self.tableView.reloadData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == self.secIndex && self.secIndex == 0{
            return 4
        }else if section == self.secIndex && self.secIndex == 1{
            return 3
        }else if section == self.secIndex && self.secIndex == 2{
            return 4
        }
        return 0
    }


}




extension LoginViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 0{
            //增加字符
            if (textField.text?.count)! > 10{
                LYProgressHUD.showError("最多11位数字！")
                self.changePhoneBtn.isHidden = false
                return false
            }else{
                if (textField.text?.count)! == 10{
                    self.changePhoneBtn.isHidden = false
                }else{
                    self.changePhoneBtn.isHidden = true
                }
            }
        }else{
            //删除字符
            self.changePhoneBtn.isHidden = true
        }
        return true
    }
}
