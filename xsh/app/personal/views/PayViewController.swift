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

    
    
    var orderNo = ""
    var money = ""
    var titleStr = ""

    var payResultBlock : ((Int) -> Void)? // 1:成功，2:取消，3:失败
    
    
    
    fileprivate var selectedPayWay1 = JSON()
    fileprivate var selectedPayWay2 : [String : JSON] = [:]
    fileprivate var payWayArray1 : Array<JSON> = []
    fileprivate var payWayArray2 : Array<JSON> = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "支付"
        
        self.tableView.register(UINib.init(nibName: "PayWayCell", bundle: Bundle.main), forCellReuseIdentifier: "PayWayCell")
        self.tableView.register(UINib.init(nibName: "PayToCell", bundle: Bundle.main), forCellReuseIdentifier: "PayToCell")
        self.tableView.register(UINib.init(nibName: "PayBtnCell", bundle: Bundle.main), forCellReuseIdentifier: "PayBtnCell")
        
        
        self.getPayWay()
        
       
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
                if json["mutex"].intValue == 1{
                    self.payWayArray1.append(json)
                }else{
                    self.payWayArray2.append(json)
                }
            }
            if self.payWayArray1.count > 0{
                self.selectedPayWay1 = self.payWayArray1.first!
            }
            self.tableView.reloadData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    
    
    //生成预付单
    @IBAction func prePayAction() {
        var params : [String : Any] = [:]
        if self.selectedPayWay1["atid"].stringValue.isEmpty{
            LYProgressHUD.showError("请选择支付方式！")
            return
        }
        params["ptid"] = self.selectedPayWay1["ptid"].stringValue
        params["atid"] = self.selectedPayWay1["atid"].stringValue
        params["destaccount"] = self.selectedPayWay1["destaccount"].stringValue
        params["orgaccount"] = self.selectedPayWay1["orgaccount"].stringValue
        params["orderno"] = self.orderNo
        
        var discount : Float = 0
        for (_, value) in self.selectedPayWay2{
            discount += value["money"].floatValue
        }
        params["money"] = self.money.floatValue - discount
        //积分
        if self.selectedPayWay2.keys.contains("98"){
            params["points"] = self.selectedPayWay2["98"]!["money"].stringValue
        }
        //ptid:支付方式,atid:货币ID,orgaccount:付款账户,destaccount:收款账户,orderno:订单号,money:付款金额,points:积分抵消费金额,coupons:使用优惠券，逗号分隔优惠券码
        NetTools.requestData(type: .post, urlString: PrePayOrderApi, parameters: params, succeed: { (result) in
            let type = result["payinfo"]["paytype"].stringValue
            if type == "alipay"{
                self.payByAli(result["payinfo"]["orderInfo"].stringValue)
            }else if type == "weixin"{
                self.payByWechat(result["payinfo"])
            }else{
                self.payByCard(result["payinfo"]["tno"].stringValue)
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
            self.cancelOrder()
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
            LYAlertView.show("提示", "请先安装微信客户端后重试！", "知道了", {
                if self.payResultBlock != nil{
                    self.payResultBlock!(3)
                }
                self.navigationController?.popViewController(animated: true)
            })
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
            self.cancelOrder()
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
    
    //使用一卡通付款
    func payByCard(_ tno : String) {
        
        let pwdView = PayPasswordView()
        pwdView.parentVC = self
        pwdView.show { (pwd) in
            
            let ts = Date.phpTimestamp()
            let cmdno = String.randomStr(len: 20) + ts
            
            var params : [String : Any] = [:]
            params["orderno"] = self.orderNo
            params["ts"] = ts
            params["cmdno"] = cmdno
            let psw = (pwd.md5String() + LocalData.getUserPhone()).md5String()
            params["paysign"] = (LocalData.getCId() + ts + cmdno + psw).md5String()
//            print("-----------------------")
//            print("ts：" + ts)
//            print("cmdno: " + cmdno)
//            print("pwd: " + pwd)
//            print("cid: " + LocalData.getCId())
//            print(psw)
//            print((LocalData.getCId() + ts + cmdno + psw).md5String())
//            print("-----------------------")
            NetTools.requestData(type: .post, urlString: CardPayApi, parameters: params, succeed: { (result) in
                //返回
                LYAlertView.show("提示", "支付成功！", "知道了", {
                    if self.payResultBlock != nil{
                        self.payResultBlock!(1)
                    }
                    self.navigationController?.popViewController(animated: true)
                })
            }) { (error) in
                LYAlertView.show("提示", "支付失败，请重试！", "知道了", {
                    if self.payResultBlock != nil{
                        self.payResultBlock!(3)
                    }
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    //取消单
    func cancelOrder() {
        let params : [String : Any] = ["orderno" : self.orderNo]
        NetTools.requestData(type: .post, urlString: CancelPrePayOrderApi, parameters: params, succeed: { (result) in
        }) { (error) in
        }
    }
    
    

}

extension PayViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 3{
            return 1
        }else if section == 1{
            return self.payWayArray1.count
        }else if section == 2{
            return self.payWayArray2.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "PayToCell", for: indexPath) as! PayToCell
            cell1.titleLbl.text = self.titleStr
            cell1.priceLbl.text = self.money
            return cell1
        }else if indexPath.section == 1{
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "PayWayCell", for: indexPath) as! PayWayCell
            if self.payWayArray1.count > indexPath.row{
                let json = self.payWayArray1[indexPath.row]
                cell2.subJson = json
                if self.selectedPayWay1["atid"].stringValue == json["atid"].stringValue{
                    cell2.selectedBtn.isSelected = true
                }else{
                    cell2.selectedBtn.isSelected = false
                }
            }
            return cell2
        }else if indexPath.section == 2{
            let cell3 = tableView.dequeueReusableCell(withIdentifier: "PayWayCell", for: indexPath) as! PayWayCell
            if self.payWayArray2.count > indexPath.row{
                let json = self.payWayArray2[indexPath.row]
                cell3.subJson = json
                if self.selectedPayWay2.keys.contains(json["atid"].stringValue){
                    cell3.selectedBtn.isSelected = true
                    cell3.useLbl.text = "-¥" + json["money"].stringValue
                }else{
                    cell3.selectedBtn.isSelected = false
                    cell3.useLbl.text = ""
                }
            }
            return cell3
        }else if indexPath.section == 3{
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "PayBtnCell", for: indexPath) as! PayBtnCell
            var discount : Float = 0
            for (_, value) in self.selectedPayWay2{
                discount += value["money"].floatValue
            }
            cell4.moneyLbl.text = "¥" + String.init(format: "%.2f", (self.money.floatValue - discount))
            cell4.payBlock = {() in
                self.prePayAction()
            }
            return cell4
        }
        return UITableViewCell()
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 140
        }else if indexPath.section == 1 || indexPath.section == 2{
            return 45
        }else if indexPath.section == 3{
            return 200
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2{
            return 5
        }
        return 0.0001
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: 5))
        view.backgroundColor = BG_Color
        return view
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 1{
            if self.payWayArray1.count > indexPath.row{
                let json = self.payWayArray1[indexPath.row]
                if self.selectedPayWay1["atid"].stringValue != json["atid"].stringValue{
                    self.selectedPayWay1 = json
                    self.tableView.reloadData()
                }
            }
        }else if indexPath.section == 2{
            if self.payWayArray2.count > indexPath.row{
                let json = self.payWayArray2[indexPath.row]
                if self.selectedPayWay2.keys.contains(json["atid"].stringValue){
                    self.selectedPayWay2.removeValue(forKey: json["atid"].stringValue)
                }else{
                    self.selectedPayWay2[json["atid"].stringValue] = json
                }
                self.tableView.reloadData()
            }
        }else if indexPath.section == 3{
            self.prePayAction()
        }
    }
}
