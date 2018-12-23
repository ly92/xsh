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
    @IBOutlet weak var bindBtn: UIButton!
    @IBOutlet weak var codeBtn: UIButton!
    
    fileprivate var timer = Timer()//
    fileprivate var codeTime : Int = 60
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "绑定实体卡"
        
        self.bindBtn.layer.cornerRadius = 25
    }
    
    

    //绑定卡
    @IBAction func bindCardAction() {
        self.view.endEditing(true)
        
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
    
    
    //获取验证码
    @IBAction func getCodeAction(_ type : Int) {
        var params : [String : Any] = [:]
        params["mobile"] = LocalData.getUserPhone()
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
