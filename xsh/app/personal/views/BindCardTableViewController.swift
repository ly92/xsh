//
//  BindCardTableViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class BindCardTableViewController: BaseTableViewController {
    class func spwan() -> BindCardTableViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! BindCardTableViewController
    }
    
    @IBOutlet weak var cardTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    //绑定卡
    func bindCardAction() {
        guard let cardNo = self.cardTF.text else {
            LYProgressHUD.showError("请输入卡号")
            return
        }
        guard let code = self.codeTF.text else {
            LYProgressHUD.showError("请输入验证码")
            return
        }
        guard let pwd = self.pwdTF.text else {
            LYProgressHUD.showError("请输入支付密码")
            return
        }
        if cardNo.isEmpty{
            LYProgressHUD.showError("请输入卡号")
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
        params["cardno"] = cardNo
        params["code"] = code
        params["passwd"] = pwd
        NetTools.requestData(type: .post, urlString: BindCardApi, parameters: params, succeed: { (result) in
            LYProgressHUD.showSuccess("")
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    
}
