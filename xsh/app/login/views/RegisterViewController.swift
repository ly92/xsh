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
    
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var stepBtn1: UIButton!
    @IBOutlet weak var stepBtn2: UIButton!
    @IBOutlet weak var stepBtn3: UIButton!
    @IBOutlet weak var stepBtn4: UIButton!
    @IBOutlet weak var goLoginLbl: UILabel!
    @IBOutlet weak var verifyPhoneLbl: UILabel!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var rePwdTF: UITextField!
    @IBOutlet weak var genderManBtn: UIButton!
    @IBOutlet weak var genderWomanBtn: UIButton!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var identityTF: UITextField!
    
    
    
    fileprivate var gender = "男"
    fileprivate var areaId = ""
    fileprivate var communityId = ""
    fileprivate var areaStr = ""
    fileprivate var communityStr = ""
    
    fileprivate var secIndex = 0//0:手机号，1:验证，2:基本信息，3:详细信息
    fileprivate var timer = Timer()//
    fileprivate var codeTime : Int = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stepBtn1.layer.cornerRadius = 25
        self.stepBtn2.layer.cornerRadius = 25
        self.stepBtn3.layer.cornerRadius = 25
        self.stepBtn4.layer.cornerRadius = 25
        
        

        let attrStr = NSMutableAttributedString()
        let attrStr1 = NSMutableAttributedString.init(string: "已有账号，去", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.RGBS(s: 166)])
        let attrStr2 = NSMutableAttributedString.init(string: "登录", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.RGB(r: 73, g: 205, b: 170)])
        attrStr.append(attrStr1)
        attrStr.append(attrStr2)
        self.goLoginLbl.attributedText = attrStr
        self.goLoginLbl.addTapActionBlock {
            self.dismiss(animated: true, completion: nil)
        }
        
        
    }

    @IBAction func btnAction(_ btn: UIButton) {
        switch btn.tag {
        case 10:
            //注册的第一个页面，下一步
            let phone = self.phoneTF.text
            if phone != nil{
                if phone!.isMobelPhone(){
                    self.getCodeAction(1)
                }else{
                    LYProgressHUD.showError("请输入11位手机号！")
                }
            }else{
                LYProgressHUD.showError("请输入11位手机号！")
            }
        case 11:
            //返回到第一步
            self.secIndex = 0
            self.tableView.reloadData()
        case 12:
            //获取验证码
            self.getCodeAction(2)
        case 13:
            //下一步，去填写基本信息
            let code = self.codeTF.text
            if code != nil{
                if !code!.isEmpty{
                    self.secIndex = 2
                    self.tableView.reloadData()
                }else{
                    LYProgressHUD.showError("请输入验证码")
                }
            }else{
                LYProgressHUD.showError("请输入验证码")
            }
        case 14:
            //返回到第一步
            self.secIndex = 1
            self.tableView.reloadData()
        case 15:
            //注册并去填写详细信息
            self.registerAction()
        case 16:
            //返回到第三步
            self.secIndex = 2
            self.tableView.reloadData()
        case 17:
            //男
            print("男")
            self.gender = "男"
        case 18:
            //女
            print("女")
            self.gender = "女"
        case 19:
            //完成，返回登录
            self.updatePersonalInfo()
        case 20:
            //跳过
            LYAlertView.show("跳过此步？", "跳过详细信息后可在个人中心补充此信息", "取消", "确定",{
                self.dismiss(animated: true, completion: nil)
            })
        default:
            print("bug")
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == self.secIndex && self.secIndex == 0{
            return 3
        }else if section == self.secIndex && self.secIndex == 1{
            return 3
        }else if section == self.secIndex && self.secIndex == 2{
            return 5
        }else if section == self.secIndex && self.secIndex == 3{
            return 5
        }
        return 0
    }

    
    
    //获取验证码
    func getCodeAction(_ type : Int) {
        let phone = self.phoneTF.text
        var params : [String : Any] = [:]
        params["mobile"] = phone!
        params["isnew"] = "1"
        NetTools.normalRequest(type: .post, urlString: GetCodeApi, parameters: params, succeed: { (result) in
            if type == 1{
                self.secIndex = 1
                self.tableView.reloadData()
                self.verifyPhoneLbl.text = "您正在使用" + phone! + "进行注册"
            }
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
    
    //注册
    func registerAction() {
        self.view.endEditing(true)
        
        let phone = self.phoneTF.text
        let code = self.codeTF.text
        guard let name = self.nameTF.text else {
            LYProgressHUD.showError("姓名输入错误")
            return
        }
        guard let pwd = self.pwdTF.text else {
            LYProgressHUD.showError("请输入密码")
            return
        }
        guard let pwd2 = self.rePwdTF.text else {
            LYProgressHUD.showError("请再次输入密码")
            return
        }
        if name.isEmpty{
            LYProgressHUD.showError("姓名输入错误")
            return
        }
        if pwd != pwd2 || pwd.isEmpty || pwd2.isEmpty || pwd.count < 6{
            LYProgressHUD.showError("请确保密码最少6位且两次输入相同")
            return
        }
        
        var params : [String : Any] = [:]
        params["mobile"] = phone!
        params["nickname"] = name
        params["passwd"] = (pwd.md5String() + phone!).md5String()
        params["code"] = code!
        NetTools.normalRequest(type: .post, urlString: RegisterApi, parameters: params, succeed: { (result) in
            LYProgressHUD.showSuccess("注册成功！")
            
            LocalData.saveUserPhone(phone: phone!)
            LocalData.saveCId(cid: result["user"]["cid"].stringValue)
            
            self.secIndex = 3
            self.tableView.reloadData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 3{
            if indexPath.row == 2{
                //地址
                let selectVC = SelectCommunityViewController.spwan()
                selectVC.areaId = self.areaId
                selectVC.areaStr = self.areaStr
                selectVC.communityId = self.communityId
                selectVC.communityStr = self.communityStr
                selectVC.selectBlok = {(areaId, areaStr, communityId, communityStr) in
                    self.areaId = areaId
                    self.communityId = communityId
                    self.areaStr = areaStr
                    self.communityStr = communityStr
                    self.addressTF.text = areaStr + communityStr
                }
                self.navigationController?.pushViewController(selectVC, animated: true)
            }
        }
    }

    //修改个人信息
    func updatePersonalInfo() {
        guard let name = self.nameTF.text else {
            LYProgressHUD.showError("姓名输入错误")
            return
        }
        if name.isEmpty{
            LYProgressHUD.showError("姓名输入错误")
            return
        }
        guard let idcard = self.identityTF.text else {
            LYProgressHUD.showError("请输入身份证号")
            return
        }
        if !idcard.isIdCard(){
            LYProgressHUD.showError("身份证号错误")
            return
        }
        
        var params : [String : Any] = [:]
        params["cid"] = LocalData.getCId()
        params["nickname"] = name
        params["idcard"] = idcard
        params["gender"] = self.gender
        params["areaid"] = self.areaId
        params["communityid"] = self.communityId
        NetTools.requestData(type: .post, urlString: ChangePersonalInfoApi, parameters: params, succeed: { (result) in
            self.dismiss(animated: true, completion: nil)
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
