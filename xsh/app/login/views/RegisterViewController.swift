//
//  RegisterViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/15.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class RegisterViewController: BaseTableViewController {
    class func spwan() -> RegisterViewController{
        return self.loadFromStoryBoard(storyBoard: "Login") as! RegisterViewController
    }
    
    
    fileprivate var secIndex = 0//0:记录了手机号，1:更改手机号，2:忘记密码，3:更改密码
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func btnAction(_ btn: UIButton) {
        switch btn.tag {
        case 10:
            //注册的第一个页面，返回到登录页
            self.dismiss(animated: true, completion: nil)
        case 11:
            //登录
            self.dismiss(animated: true, completion: nil)
        case 12:
            //注册第一页----下一步
            self.dismiss(animated: false, completion: nil)
        case 13:
            //返回到第一步
            self.secIndex = 0
            self.tableView.reloadData()
        case 14:
            //获取验证码
            print("1")
        case 15:
            //去填写密码
            self.secIndex = 2
            self.tableView.reloadData()
        case 16:
            //返回到第二步
            self.secIndex = 1
            self.tableView.reloadData()
        case 17:
            //去填写详细信息
            self.secIndex = 3
            self.tableView.reloadData()
        case 18:
            //填写详细信息的返回
            self.secIndex = 2
            self.tableView.reloadData()
        case 19:
            //男
            print("男")
        case 20:
            //女
            print("女")
        case 21:
            //完成，返回登录
            self.dismiss(animated: true, completion: nil)
        default:
            print("bug")
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == self.secIndex && self.secIndex == 0{
            return 4
        }else if section == self.secIndex && self.secIndex == 1{
            return 4
        }else if section == self.secIndex && self.secIndex == 2{
            return 5
        }else if section == self.secIndex && self.secIndex == 3{
            return 5
        }
        return 0
    }

    
}
