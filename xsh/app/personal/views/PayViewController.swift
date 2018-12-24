//
//  PayViewController.swift
//  xsh
//
//  Created by ly on 2018/12/21.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class PayViewController: BaseTableViewController {
    class func spwan() -> PayViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! PayViewController
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    
    @IBOutlet weak var wechatBtn: UIButton!
    @IBOutlet weak var aliBtn: UIButton!
    @IBOutlet weak var cardBtn: UIButton!
    
    @IBOutlet weak var couponBtn: UIButton!
    @IBOutlet weak var couponLbl: UILabel!
    @IBOutlet weak var pointsBtn: UIButton!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var totalMoneyLbl: UILabel!
    @IBOutlet weak var payBtn: UIButton!
    
    @IBOutlet weak var cardMoneyLbl: UILabel!
    @IBOutlet weak var couponCanUseLbl: UILabel!
    @IBOutlet weak var pointsCanUseLbl: UILabel!
    
    
    var orderNo = ""
    var money = ""
    var titleStr = ""
    
    var payResultBlock : ((Int) -> Void)? // 1:成功，2:取消，3:失败
    
    fileprivate var payType : [String : JSON] = [:]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "支付"
        self.payBtn.layer.cornerRadius = 25
        
        self.getPayWay()
        
        
        self.titleLbl.text = self.titleStr
        self.moneyLbl.text =  self.money
        self.totalMoneyLbl.text = "¥" + self.money
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.removeNoti()
        //微信支付结果通知
        NotificationCenter.default.addObserver(self, selector: #selector(PayViewController.wechatPayResult(_:)), name: NSNotification.Name(rawValue: KWechatPayNotiName), object: nil)
    }
    
    func removeNoti() {
        //移除微信支付结果通知
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: KWechatPayNotiName), object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeNoti()
    }
    
    
    //支付方式
    func getPayWay() {
        let params : [String : Any] = ["orderno" : self.orderNo]
        NetTools.requestData(type: .post, urlString: PayTypeApi, parameters: params, succeed: { (result) in
            for json in result["list"].arrayValue{
                self.payType[json["name"].stringValue] = json
            }
            
            self.tableView.reloadData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    @IBAction func payWayAction(_ btn : UIButton){
        if btn.tag == 11{
            self.wechatBtn.isSelected = true
            self.aliBtn.isSelected = false
            self.cardBtn.isSelected = false
        }else if btn.tag == 22{
            self.wechatBtn.isSelected = false
            self.aliBtn.isSelected = true
            self.cardBtn.isSelected = false
        }else if btn.tag == 33{
            self.wechatBtn.isSelected = false
            self.aliBtn.isSelected = false
            self.cardBtn.isSelected = true
        }else if btn.tag == 44{
            self.couponBtn.isSelected = !self.couponBtn.isSelected
        }else if btn.tag == 55{
            self.pointsBtn.isSelected = !self.pointsBtn.isSelected
        }
//        self.tableView.reloadData()
    }
    
    
    //生成预付单
    @IBAction func prePayAction() {
        var params : [String : Any] = [:]
        
        var payJson = JSON()
        if self.wechatBtn.isSelected{
            payJson = self.payType["微信支付"]!
        }else if self.aliBtn.isSelected{
           payJson = self.payType["支付宝"]!
        }else if self.cardBtn.isSelected{
            payJson = self.payType["一卡通"]!
        }
        params["ptid"] = payJson["ptid"].stringValue
        params["atid"] = payJson["atid"].stringValue
        params["destaccount"] = payJson["destaccount"].stringValue
        if !payJson["orgaccount"].stringValue.isEmpty{
            params["orgaccount"] = payJson["orgaccount"].stringValue
        }
        params["orderno"] = self.orderNo
        params["money"] = self.money
        //ptid:支付方式,atid:货币ID,orgaccount:付款账户,destaccount:收款账户,orderno:订单号,money:付款金额,points:积分抵消费金额,coupons:使用优惠券，逗号分隔优惠券码
        NetTools.requestData(type: .post, urlString: PrePayOrderApi, parameters: params, succeed: { (result) in
            let type = result["payinfo"]["paytype"].stringValue
            if type == "alipay"{
                self.payByAli(result["payinfo"]["orderInfo"].stringValue)
            }else if type == "weixin"{
                self.payByWechat(result["payinfo"])
            }
            
        }) { (error) in
            LYProgressHUD.showError(error)
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
                if self.payResultBlock != nil{
                    self.payResultBlock!(1)
                }
                self.navigationController?.popViewController(animated: true)
            })
        }else if resultDict!["resultStatus"] as! String == "6001"{
            //支付取消
            LYAlertView.show("提示", "支付取消！", "知道了", {
                if self.payResultBlock != nil{
                    self.payResultBlock!(2)
                }
                self.navigationController?.popViewController(animated: true)
            })
        }else{
            //支付失败
            LYAlertView.show("提示", "支付失败！", "知道了", {
                if self.payResultBlock != nil{
                    self.payResultBlock!(3)
                }
                self.navigationController?.popViewController(animated: true)
            })
        }
        
    }
    
    
    //使用微信付款
    func payByWechat(_ reqJson : JSON) {
        if WXApi.isWXAppInstalled(){
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
            LYProgressHUD.showError("请先安装微信客户端！")
        }
    }
    //微信支付结果
    @objc func wechatPayResult(_ noti:Notification) {
        guard let resultDict = noti.userInfo as? [String:String] else {
            return
        }
        if resultDict["code"] == "0"{
            //返回
            LYAlertView.show("提示", "支付成功！", "知道了", {
                if self.payResultBlock != nil{
                    self.payResultBlock!(1)
                }
                self.navigationController?.popViewController(animated: true)
            })
        }else if resultDict["code"] == "-2"{
            //取消支付
            LYAlertView.show("提示", "支付取消！", "知道了", {
                if self.payResultBlock != nil{
                    self.payResultBlock!(2)
                }
                self.navigationController?.popViewController(animated: true)
            })
        }else{
            //支付失败
            LYAlertView.show("提示", "支付失败！", "知道了", {
                if self.payResultBlock != nil{
                    self.payResultBlock!(3)
                }
                self.navigationController?.popViewController(animated: true)
            })
        }
    }
    
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 140
        }else if indexPath.row == 1{
            return 55
        }else if indexPath.row == 2{
            if self.payType.keys.contains("微信支付"){
                return 45
            }
        }else if indexPath.row == 3{
            if self.payType.keys.contains("支付宝"){
                return 45
            }
        }else if indexPath.row == 4{
            if self.payType.keys.contains("一卡通"){
                return 45
            }
        }else if indexPath.row == 5{
            if self.payType.keys.contains("优惠券"){
                return 45
            }
        }else if indexPath.row == 6{
            if self.payType.keys.contains("积分"){
                return 45
            }
        }else if indexPath.row == 7{
            return 55
        }else if indexPath.row == 8{
            return 140
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.row == 2{
            let btn = UIButton()
            btn.tag = 11
            self.payWayAction(btn)
        }else if indexPath.row == 3{
            let btn = UIButton()
            btn.tag = 22
            self.payWayAction(btn)
        }else if indexPath.row == 4{
            let btn = UIButton()
            btn.tag = 33
            self.payWayAction(btn)
        }else if indexPath.row == 5{
            let btn = UIButton()
            btn.tag = 44
            self.payWayAction(btn)
        }else if indexPath.row == 6{
            let btn = UIButton()
            btn.tag = 55
            self.payWayAction(btn)
        }
    }
    

}
