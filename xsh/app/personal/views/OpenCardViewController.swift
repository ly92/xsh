//
//  OpenCardViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class OpenCardViewController: BaseViewController {
    class func spwan() -> OpenCardViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! OpenCardViewController
    }
    
    var openSucBlock : (() -> Void)?
    
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var tf5: UITextField!
    @IBOutlet weak var tf6: UITextField!
    @IBOutlet weak var openBtn: UIButton!
    
    fileprivate var sourceArray : Array<UITextField> = Array<UITextField>()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "开通一卡通"

        self.sourceArray.append(tf1)
        self.sourceArray.append(tf2)
        self.sourceArray.append(tf3)
        self.sourceArray.append(tf4)
        self.sourceArray.append(tf5)
        self.sourceArray.append(tf6)
        
        tf1.layer.borderColor = UIColor.RGBS(s: 191).cgColor
        tf2.layer.borderColor = UIColor.RGBS(s: 191).cgColor
        tf3.layer.borderColor = UIColor.RGBS(s: 191).cgColor
        tf4.layer.borderColor = UIColor.RGBS(s: 191).cgColor
        tf5.layer.borderColor = UIColor.RGBS(s: 191).cgColor
        tf6.layer.borderColor = UIColor.RGBS(s: 191).cgColor
        
        self.openBtn.layer.cornerRadius = 25
        self.pwdTF.becomeFirstResponder()
    }
    
    @IBAction func openCardAction() {
        self.view.endEditing(true)
        
        guard let pwd = self.pwdTF.text else {
            LYProgressHUD.showError("请输入密码！")
            return
        }
        if pwd.count != 6 || pwd.intValue == 0{
            LYProgressHUD.showError("密码必须为6位不同数字")
        }
        let ts = Date.phpTimestamp()
        let cmdno = String.randomStr(len: 20) + ts
        var params : [String : Any] = [:]
//        params["passwd"] = (LocalData.getCId() + ts + cmdno + (pwd.md5String() + LocalData.getUserPhone()).md5String()).md5String()
         params["passwd"] = (pwd.md5String() + LocalData.getUserPhone()).md5String()
        params["cmdno"] = cmdno
        params["ts"] = ts
        NetTools.requestData(type: .post, urlString: OpenCardApi, parameters: params, succeed: { (result) in
            LYProgressHUD.showSuccess("开卡成功！")
            if self.openSucBlock != nil{
                self.openSucBlock!()
            }
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    

}


extension OpenCardViewController : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.length == 0{
            //增加字符
            if (textField.text?.count)! > 5{
                LYProgressHUD.showError("最多6位数字！")
                return false
            }else{
                let TF = sourceArray[(textField.text?.count)!]
                TF.text = string
            }
        }else{
            //删除字符
            let TF = sourceArray[(textField.text?.count)! - 1]
            TF.text = ""
        }
        return true
    }
}
