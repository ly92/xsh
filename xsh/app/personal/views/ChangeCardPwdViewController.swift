//
//  ChangeCardPwdViewController.swift
//  xsh
//
//  Created by ly on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class ChangeCardPwdViewController: BaseTableViewController {
    class func spwan() -> ChangeCardPwdViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! ChangeCardPwdViewController
    }
    
    @IBOutlet weak var pwdTF1: UITextField!
    @IBOutlet weak var pwdTF2: UITextField!
    @IBOutlet weak var pwdTF3: UITextField!
    @IBOutlet weak var modifyBtn: UIButton!
    
    
    @IBOutlet weak var pwdTF4: UITextField!
    @IBOutlet weak var pwdTF5: UITextField!
    @IBOutlet weak var pwdTF6: UITextField!
    @IBOutlet weak var modifyBtn2: UIButton!
    @IBOutlet weak var forgetBtn: UIButton!
    
    
    var isChangeLogin = false
    
    fileprivate var forgetType = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.modifyBtn.layer.cornerRadius = 25
        self.modifyBtn2.layer.cornerRadius = 25
        
        if self.isChangeLogin{
            self.forgetBtn.isHidden = true
            self.navigationItem.title = "修改登录密码"
        }else{
            self.navigationItem.title = "修改支付密码"
        }
    }
    
    
    @IBAction func forgetPayPwdAction() {
        self.forgetType = true
        self.tableView.reloadData()
    }
    
    
    @IBAction func changeCardPayPwd() {
        self.view.endEditing(true)
        
        if self.forgetType{
            
            guard let loginPwd = self.pwdTF4.text else {
                LYProgressHUD.showError("请输入登录密码")
                return
            }
            guard let pwd2 = self.pwdTF5.text else {
                LYProgressHUD.showError("请输入新密码")
                return
            }
            guard let pwd3 = self.pwdTF6.text else {
                LYProgressHUD.showError("请输入新密码")
                return
            }
            
            if pwd2 != pwd3{
                LYProgressHUD.showError("两次输入的新密码不一致！")
                return
            }
            
            if loginPwd.isEmpty || pwd2.isEmpty{
                LYProgressHUD.showError("密码不可为空，且不可相同")
                return
            }
            
            
            var params : [String : Any] = [:]
            params["paypsw"] = (pwd2.md5String() + LocalData.getUserPhone()).md5String()
            params["passwd"] = (LocalData.getUserPhone() + Date.phpTimestamp() + (loginPwd.md5String() + LocalData.getUserPhone()).md5String()).md5String()
            NetTools.requestData(type: .post, urlString: CardResetPayPwdApi, parameters: params, succeed: { (result) in
                LYProgressHUD.showSuccess("密码更改成功！")
                self.navigationController?.popViewController(animated: true)
            }) { (error) in
                LYProgressHUD.showError(error)
            }
        }else{
            
            guard let pwd1 = self.pwdTF1.text else {
                LYProgressHUD.showError("请输入旧密码")
                return
            }
            guard let pwd2 = self.pwdTF2.text else {
                LYProgressHUD.showError("请输入新密码")
                return
            }
            guard let pwd3 = self.pwdTF3.text else {
                LYProgressHUD.showError("请输入新密码")
                return
            }
            
            if pwd2 != pwd3{
                LYProgressHUD.showError("两次输入的新密码不一致！")
                return
            }
            
            if pwd1.isEmpty || pwd2.isEmpty || pwd1 == pwd2{
                LYProgressHUD.showError("新旧密码不可为空，且不可相同")
                return
            }
            
            if self.isChangeLogin{
                var params : [String : Any] = [:]
                params["oldpasswd"] = (pwd1.md5String() + LocalData.getUserPhone()).md5String()
                params["newpasswd"] = (pwd2.md5String() + LocalData.getUserPhone()).md5String()
                NetTools.requestData(type: .post, urlString: ChangeLoginPwdApi, parameters: params, succeed: { (result) in
                    LYProgressHUD.showSuccess("密码更改成功！")
                    LocalData.savePwd(pwd: (pwd2.md5String() + LocalData.getUserPhone()).md5String())
                    LocalData.saveTruePwd(pwd: pwd2)
                    self.navigationController?.popViewController(animated: true)
                }) { (error) in
                    LYProgressHUD.showError(error)
                }
            }else{
                var params : [String : Any] = [:]
                params["oldpasswd"] = (pwd1.md5String() + LocalData.getUserPhone()).md5String()
                params["newpasswd"] = (pwd2.md5String() + LocalData.getUserPhone()).md5String()
                NetTools.requestData(type: .post, urlString: CardChangePwdApi, parameters: params, succeed: { (result) in
                    LYProgressHUD.showSuccess("密码更改成功！")
                    self.navigationController?.popViewController(animated: true)
                }) { (error) in
                    LYProgressHUD.showError(error)
                }
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if forgetType{
            if section == 1{
                return 4
            }
        }else{
            if section == 0{
                return 4
            }
        }
        return 0
    }
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}
