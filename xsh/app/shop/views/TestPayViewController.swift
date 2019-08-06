//
//  TestPayViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/8/4.
//  Copyright © 2019 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class TestPayViewController: BaseViewController {
    class func spwan() -> TestPayViewController{
        return self.loadFromStoryBoard(storyBoard: "Shop") as! TestPayViewController
    }
    
    @IBOutlet weak var moneyTf: UITextField!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "支付测试"

         self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "扫描", target: self, action: #selector(TestPayViewController.scanAction))
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnAction(_ btn: UIButton) {
        self.moneyTf.resignFirstResponder()
        if btn.tag == 11{
            //微信
            self.btn1.isSelected = true
            self.btn2.isSelected = false
        }else if btn.tag == 22{
            //支付宝
            self.btn1.isSelected = false
            self.btn2.isSelected = true
        }else if btn.tag == 99{
            //提交
            if self.btn1.isSelected{
                self.wechatAction()
            }else{
                self.aliAction()
            }
            
        }
    }
    
    func aliAction() {
        var money = self.moneyTf.text ?? "0.01"
        if money.floatValue <= 0{
            money = "0.01"
        }
        let url = "http://localcommonwealbank.test.wwwcity.net/transaction/prepay"
        let params : [String : Any] = ["desttype":131, "destaccountno":"113111914a5e9665417b8f44394159d9", "money":money, "orderno":String.randomStr(len: 16), "content":"智慧城市测试支付-支付宝", "remoteip":"119.90.91.21"]
        NetTools.requestCustom(urlString: url, parameters: params, succeed: { (result) in
            self.payByAli(result["content"]["payinfo"]["orderInfo"].stringValue)
        }) { (error) in
            LYProgressHUD.showError(error ?? "未配置支付宝支付账户信息")
        }
    }
    
    func wechatAction() {
        var money = self.moneyTf.text ?? "0.01"
        if money.floatValue <= 0{
            money = "0.01"
        }
        let url = "http://localcommonwealbank.test.wwwcity.net/transaction/prepay"
        let params : [String : Any] = ["desttype":132, "destaccountno":"1132c2554b9c951845ffa1f65bc3aaa1", "money":money, "orderno":String.randomStr(len: 16), "content":"智慧城市测试支付-微信", "remoteip":"119.90.91.21"]
        NetTools.requestCustom(urlString: url, parameters: params, succeed: { (result) in
            self.wechatPay(result["content"]["payinfo"])
        }) { (error) in
            LYProgressHUD.showError(error ?? "未配置微信支付账户信息")
        }
    }
    
    
    //使用支付宝付款
    func payByAli(_ orderString : String) {
        AlipaySDK.defaultService().payOrder(orderString, fromScheme: KAliPayScheme) { (resultDict) in
            self.aliPayResult(resultDict)
        }
    }
    
    func aliPayResult(_ resultDict:[AnyHashable:Any]?) {
        if resultDict == nil{
            return
        }
        if resultDict!["resultStatus"] as! String == "9000"{
            //返回
            LYAlertView.show("提示", "支付成功！", "知道了", {
               
            })
        }else if resultDict!["resultStatus"] as! String == "6001"{
            //支付取消
            LYAlertView.show("提示", "支付取消！", "知道了", {
                
            })
        }else{
            //支付失败
            LYAlertView.show("提示", "支付失败！", "知道了", {
                
            })
        }
        
    }
    
    
    
    func wechatPay(_ reqJson : JSON) {
        if WXApi.isWXAppInstalled(){
            
            //注册微信
            WXApi.registerApp(reqJson["appId"].stringValue)
            
            let req = PayReq()
            req.openID = reqJson["appId"].stringValue
            req.partnerId = reqJson["partnerId"].stringValue
            req.prepayId = reqJson["prepayId"].stringValue
            req.nonceStr = reqJson["nonceStr"].stringValue
            req.timeStamp = UInt32(reqJson["timeStamp"].stringValue)!
            req.package = reqJson["packageValue"].stringValue
            req.sign = reqJson["sign"].stringValue
            print(WXApi.send(req))
        }else{
            //取消支付
            LYAlertView.show("提示", "请先安装微信客户端后重试！", "知道了", {
                
            })
        }
    }
    
    
    
    
    
    
    
    
    
    @objc func scanAction(){
        let scanVC = ScanActionViewController()
        scanVC.scanResultBlock = {(result) in
            
            let temp = result.replacingOccurrences(of: "http://", with: "").replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "test.", with: "")
            
            let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH))
            view.backgroundColor = BG_Color
            
            
            let lbl = UILabel()
            lbl.numberOfLines = 0
            lbl.text = temp
            lbl.font = UIFont.systemFont(ofSize: 14.0)
            lbl.textColor = Text_Color
            view.addSubview(lbl)
            lbl.snp.makeConstraints({ (make) in
                make.leading.equalTo(20)
                make.trailing.equalTo(-20)
                make.top.equalTo(50)
            })
            
            UIApplication.shared.keyWindow?.addSubview(view)
            UIApplication.shared.keyWindow?.bringSubviewToFront(view)
            
            
            view.addTapActionBlock(action: {
                view.removeFromSuperview()
            })
        }
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
    
}
