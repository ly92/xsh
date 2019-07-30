//
//  POSViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/5/17.
//  Copyright © 2019 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class POSViewController: BaseViewController {
    class func spwan() -> POSViewController{
        return self.loadFromStoryBoard(storyBoard: "Shop") as! POSViewController
    }
    
    @IBOutlet weak var moneyTF: UITextField!
    
    @IBOutlet weak var bnt1: UIButton!
    @IBOutlet weak var bnt2: UIButton!
    @IBOutlet weak var bnt3: UIButton!
    @IBOutlet weak var bnt4: UIButton!
    @IBOutlet weak var bnt5: UIButton!
    @IBOutlet weak var bnt6: UIButton!
    @IBOutlet weak var bnt7: UIButton!
    @IBOutlet weak var bnt8: UIButton!
    private var selectedBtn = UIButton()
    
    private var type = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "收银台"
        self.view.addTapActionBlock {
            self.moneyTF.resignFirstResponder()
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "通讯录", target: self, action: #selector(POSViewController.contact))
        
    }
    
    @objc func contact(){
        let contactVC = ContactTableViewController()
        self.navigationController?.pushViewController(contactVC, animated: true)
    }
    
    @IBAction func btnAction(_ btn: UIButton) {
        self.moneyTF.resignFirstResponder()
        if self.selectedBtn.tag == btn.tag{
            return
        }
        if btn.tag < 90{
            self.selectedBtn.isSelected = false
            self.selectedBtn = btn
            self.selectedBtn.isSelected = true
        }
        if btn.tag == 11{
            //微信-付款码
            self.type = 1
        }else if btn.tag == 22{
            //微信-二维码
            self.type = 2
        }else if btn.tag == 33{
            //支付宝-付款码
            self.type = 3
        }else if btn.tag == 44{
            //支付宝-二维码
            self.type = 4
        }else if btn.tag == 55{
            //支付宝-App1
            self.type = 5
        }else if btn.tag == 66{
            //微信-App1
            self.type = 6
        }else if btn.tag == 77{
            //支付宝-App2
            self.type = 7
        }else if btn.tag == 88{
            //微信-App2
            self.type = 8
        }else if btn.tag == 99{
            //提交
            self.createOrder()
        }
    }
    

}


extension POSViewController{
    //创建订单
    func createOrder() {
        let url = "http://106.12.211.34:1226/test/testprepay"
        var params : [String:Any] = [:]
        params["type"] = self.type
        params["order"] = String.randomStr(len: 15)
        
        //调用扫描
        func scan(){
            let scanVC = ScanActionViewController()
            scanVC.scanResultBlock = {(result) in
                params["auth_code"] = result
                //请求金融平台
                request()
            }
            self.navigationController?.pushViewController(scanVC, animated: true)
        }
        
        //请求金融平台
        func request(){
            NetTools.requestCustom(urlString: url, parameters: params, succeed: { (result) in
                DispatchQueue.main.async {
                    if self.bnt1.isSelected{
                        //微信-付款码
                        
                    }else if self.bnt2.isSelected{
                        //微信-二维码
                        self.showCode(result["code_url"].stringValue)
                    }else if self.bnt3.isSelected{
                        //支付宝-付款码
                        if result["orderInfo"]["alipay_trade_pay_response"]["code"].stringValue == "10000"{
                            LYProgressHUD.showSuccess("收款成功！")
                        }else{
                            LYProgressHUD.showError(result["orderInfo"]["alipay_trade_pay_response"]["msg"].stringValue)
                        }
                    }else if self.bnt4.isSelected{
                        //支付宝-二维码
                        self.showCode(result["orderInfo"]["alipay_trade_precreate_response"]["qr_code"].stringValue)
                    }else if self.bnt5.isSelected{
                        //支付宝-App1
                        self.payByAli(result["orderInfo"].stringValue)
                    }else if self.bnt6.isSelected{
                        //微信-App1
                        self.payByWechat(result)
                    }else if self.bnt7.isSelected{
                        //支付宝-App2
                        self.payByAli(result["orderInfo"].stringValue)
                    }else if self.bnt8.isSelected{
                        //微信-App2
                        self.payByWechat(result)
                    }
                }
            }) { (error) in
                LYProgressHUD.showError(error ?? "请求错误")
            }
        }
        
        if self.bnt1.isSelected{
            //微信-付款码
            scan()
        }else if self.bnt2.isSelected{
            //微信-二维码
            request()
        }else if self.bnt3.isSelected{
            //支付宝-付款码
            params["scene"] = "bar_code"
            scan()
        }else if self.bnt4.isSelected{
            //支付宝-二维码
            request()
        }else if self.bnt5.isSelected{
            //支付宝-App1
            request()
        }else if self.bnt6.isSelected{
            //微信-App1
            request()
        }else if self.bnt7.isSelected{
            //支付宝-App2
            request()
        }else if self.bnt8.isSelected{
            //微信-App2
            request()
        }
        
    }
    
    
    //展示二维码
    func showCode(_ qrcode:String) {
        let codeView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH))
        codeView.backgroundColor = UIColor.white
        let codeImgV = UIImageView.init(frame: CGRect.init(x: kScreenW / 2.0 - 125, y: kScreenH / 2.0 - 125, width: 250, height: 250))
        codeImgV.image = UIImageView.createQrcode(qrcode)
        codeView.addSubview(codeImgV)
        AppDelegate.sharedInstance.window?.addSubview(codeView)
        codeView.addTapActionBlock {
            codeView.removeFromSuperview()
        }
    }
    
    
    
    
    //使用支付宝付款
    func payByAli(_ orderString : String) {
        AlipaySDK.defaultService().payOrder(orderString, fromScheme: KAliPayScheme) { (resultDict) in
        }
    }
    
    
    //使用微信付款
    func payByWechat(_ reqJson : JSON) {
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
    
}

/**
 "-----------返回数据--------"
 {
 "orderInfo" : {
 "alipay_trade_precreate_response" : {
 "qr_code" : "https:\/\/qr.alipay.com\/bax03021gvyzseafeutr60ea",
 "code" : "10000",
 "msg" : "Success",
 "out_trade_no" : "12312313123123"
 },
 "sign" : "IsXiiU2fZnJjuX79TGBE7jAkxkZd5VB4X8OQe\/gGoxGgyjk4k75W9K5h7jc1Iwu05BRvgotEfVph70XJZwpvYf3J1BObE4HUbEM0AXfpuzKS+Aju7F9SYqh7BYqYg2Z0jMVWpHdXN9cWF7ldXwz025OF94SrQ8cARiGcS+CmZVMFeZ3pVqQYyByxim+xgHxc8SiBZ8NmrqvErBsuMTRfO+39KnSlNoLq\/tqN9YHKOcCfLE5nAgnhQnq5osJH9QuVo67reMn437jpqRCyKdCorlu0o6quND6iuq4omzJiiOaR9XXM1JsINyVtxQ6kz6BcIncY9LBoqGWnSPGznLX1AQ=="
 }
 }
 "-----------返回数据--------"
 {
 "orderInfo" : {
 "alipay_trade_precreate_response" : {
 "msg" : "Success",
 "code" : "10000",
 "out_trade_no" : "1231231312312322",
 "qr_code" : "https:\/\/qr.alipay.com\/bax071168gdpjwead2eb80ad"
 },
 "sign" : "SniqCf1lRhh\/l1Z1QanGYy3olHDfrAZw5xwTvNjhlQm9azLq3N7Oo7PvnOt\/C6CQ02pvfis1QMmWYF33FhbM5tyLXE6rsOAM2pJDVCMKDXMvK92s86wFMg8pjA1+jOGRqCENBTrg3M0lQK16vbez1QPiPH4qfQQEqjm\/s1D3zToBm\/OcNmrKgRJXzsF3pEovf+HTFgEtYdSzJlRTW2+CSnICO8dr1gWBjzPXjJ59fDK+n9FBoxDvTeTAz6o66bRt\/c6W6xD\/8WEKBLb+7XURwddeb\/wMw3CWrnTgTt0ngfiX2tnhrD3SmJ+fO1grP3w1OQhCTxEgnIsEpu9pDRbzcg=="
 }
 }
 "-----------返回数据--------"
 {
 "code_url": "weixin://wxpay/bizpayurl?pr=cmNoNzr",
 "sign": "661AFA42D0454D79B808984B810EB4DC",
 "partnerId": "1539628431",
 "prepayId": "wx13174931264306c87467361d1442686700",
 "nonceStr": "7ZiwaYTErCaTiGRY",
 "timeStamp": 1560419371,
 "packageValue": "Sign=WXPay",
 "appId": "wx14b06ec2e4b5d070"
 }
 "-----------错误数据--------"
 Alamofire.AFError.responseSerializationFailed(reason: Alamofire.AFError.ResponseSerializationFailureReason.jsonSerializationFailed(error: Error Domain=NSCocoaErrorDomain Code=3840 "Invalid value around character 0." UserInfo={NSDebugDescription=Invalid value around character 0.}))

 */
