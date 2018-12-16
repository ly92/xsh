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
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginBtn.layer.contents = 25
        self.nextBtn.layer.contents = 25
        self.resetBtn.layer.contents = 25
    }

    @IBAction func getCodeAction() {
        var params : [String : Any] = [:]
        params["mobile"] = "18811016533"
        params["isnew"] = "1"
        NetTools.requestDataTest(urlString: GetCodeApi, parameters: params, succeed: { (result) in
            
        }) { (error) in
            
        }
    }
    
    @IBAction func toLoginAction() {
        self.dismiss(animated: true, completion: {
            
        })
    }
    
    
    @IBAction func loginAction() {
        var params : [String : Any] = [:]
        params["mobile"] = "18811016533"
        params["nickname"] = "ly"
        params["passwd"] = ("111111".md5String() + "18811016533").md5String()
        params["code"] = "4658"
        NetTools.requestDataTest(urlString: RegidterApi, parameters: params, succeed: { (result) in
            
        }) { (error) in
            
        }
    }
    
    
    
    
    @IBAction func btnAction(_ btn: UIButton) {
        switch btn.tag {
        case 11:
            //切换手机号
            self.loginPhoneTF.text = ""
            
        case 22:
        //登录
            self.dismiss(animated: false, completion: nil)
        case 33:
            //忘记密码
            self.secIndex = 1
            self.tableView.reloadData()
            
        
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
            print("1")
        case 77:
            //去设置新密码
            self.secIndex = 2
            self.tableView.reloadData()
        case 88:
            //设置新密码的返回
            self.secIndex = 1
            self.tableView.reloadData()
        case 99:
            //确认设置新密码
            self.secIndex = 0
            self.tableView.reloadData()
        default:
            print("bug")
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
