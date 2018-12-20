//
//  OpenCardViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class OpenCardViewController: BaseViewController {
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    @IBOutlet weak var tf3: UITextField!
    @IBOutlet weak var tf4: UITextField!
    @IBOutlet weak var tf5: UITextField!
    @IBOutlet weak var tf6: UITextField!
    
    fileprivate var sourceArray : Array<UITextField> = Array<UITextField>()
    override func viewDidLoad() {
        super.viewDidLoad()



        self.sourceArray.append(tf1)
        self.sourceArray.append(tf2)
        self.sourceArray.append(tf3)
        self.sourceArray.append(tf4)
        self.sourceArray.append(tf5)
        self.sourceArray.append(tf6)

    }
    

    func openCard() {
        guard let pwd = self.pwdTF.text else {
            LYProgressHUD.showError("请输入密码！")
            return
        }
        if pwd.count != 6 || pwd.intValue == 0{
            LYProgressHUD.showError("密码必须为6位不同数字")
        }
        let params : [String : Any] = ["passwd" : pwd]
        NetTools.requestData(type: .post, urlString: OpenCardApi, parameters: params, succeed: { (result) in
            
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
