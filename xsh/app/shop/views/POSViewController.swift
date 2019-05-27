//
//  POSViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/5/17.
//  Copyright © 2019 wwzb. All rights reserved.
//

import UIKit

class POSViewController: BaseViewController {
    class func spwan() -> POSViewController{
        return self.loadFromStoryBoard(storyBoard: "Shop") as! POSViewController
    }
    
    @IBOutlet weak var moneyTF: UITextField!
    
    @IBOutlet weak var bnt1: UIButton!
    @IBOutlet weak var bnt2: UIButton!
    @IBOutlet weak var bnt3: UIButton!
    @IBOutlet weak var bnt4: UIButton!
    private var selectedBtn = UIButton()
    
    private var type = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "收银台"
        self.view.addTapActionBlock {
            self.moneyTF.resignFirstResponder()
        }
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
                        self.showCode("")
                    }else if self.bnt3.isSelected{
                        //支付宝-付款码--
                        
                    }else if self.bnt4.isSelected{
                        //支付宝-二维码
                        self.showCode(result["orderInfo"]["alipay_trade_precreate_response"]["qr_code"].stringValue)
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
            scan()
        }else if self.bnt4.isSelected{
            //支付宝-二维码
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
 "sign" : "D4256BA6FC341EEEC30CA145BAB74BE0",
 "appId" : "wxbff455048a79dd5f",
 "partnerId" : "1526857431",
 "packageValue" : "Sign=WXPay",
 "prepayId" : "wx17172855553599eea01eae9c2199506123",
 "timeStamp" : 1558085335,
 "nonceStr" : "xLeI7pGDfoPu4Woe"
 }
 "-----------错误数据--------"
 Alamofire.AFError.responseSerializationFailed(reason: Alamofire.AFError.ResponseSerializationFailureReason.jsonSerializationFailed(error: Error Domain=NSCocoaErrorDomain Code=3840 "Invalid value around character 0." UserInfo={NSDebugDescription=Invalid value around character 0.}))

 */
