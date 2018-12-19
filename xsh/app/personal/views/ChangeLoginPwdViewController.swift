//
//  ChangeLoginPwdViewController.swift
//  xsh
//
//  Created by ly on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class ChangeLoginPwdViewController: BaseTableViewController {
    class func spwan() -> ChangeLoginPwdViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! ChangeLoginPwdViewController
    }
    
    @IBOutlet weak var pwdTF1: UITextField!
    @IBOutlet weak var pwdTF2: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    func changeLoginPwd() {
        guard let pwd1 = self.pwdTF1.text else {
            LYProgressHUD.showError("请输入旧密码")
            return
        }
        guard let pwd2 = self.pwdTF2.text else {
            LYProgressHUD.showError("请输入新密码")
            return
        }
        
        if pwd1.isEmpty || pwd2.isEmpty || pwd1 == pwd2{
            LYProgressHUD.showError("新旧密码不可为空，且不可相同")
            return
        }
        
        var params : [String : Any] = [:]
        params["oldpasswd"] = pwd1
        params["newpasswd"] = pwd2
        NetTools.requestData(type: .post, urlString: ChangePwdApi, parameters: params, succeed: { (result) in
            LYProgressHUD.showSuccess("密码更改成功！")
            LocalData.savePwd(pwd: pwd2)
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    
}
