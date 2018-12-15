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
    
    fileprivate var secIndex = 0//0:记录了手机号，1:更改手机号，2:忘记密码，3:更改密码
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
            //忘记密码
            self.secIndex = 2
            self.tableView.reloadData()
        case 22:
        //切换手机号
            self.secIndex = 1
            self.tableView.reloadData()
        case 33:
        //登录记录的账户
            self.dismiss(animated: false, completion: nil)
        case 44:
        //去注册
            let registerVC = RegisterViewController.spwan()
            self.present(registerVC, animated: true) {
                
            }
        case 55:
        //确认登录新手机号
            self.dismiss(animated: false, completion: nil)
        case 66:
        //点击忘记密码后的返回
            self.secIndex = 0
            self.tableView.reloadData()
        case 77:
        //获取验证码
            print("1")
        case 88:
        //去设置新密码
            self.secIndex = 3
            self.tableView.reloadData()
        case 99:
        //设置新密码的返回
            self.secIndex = 2
            self.tableView.reloadData()
        case 10:
        //确认设置新密码
            self.secIndex = 0
            self.tableView.reloadData()
        default:
            print("bug")
        }
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == self.secIndex{
            return 4
        }
        return 0
    }


}
