//
//  RegisterViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/13.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
    class func spwan() -> RegisterViewController{
        return self.loadFromStoryBoard(storyBoard: "Login") as! RegisterViewController
    }
    
    @IBAction func phoneTF(_ sender: Any) {
    }
    @IBAction func codeTF(_ sender: Any) {
    }
    @IBAction func nameTF(_ sender: Any) {
    }
    @IBAction func pwdTF(_ sender: Any) {
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
    
}
