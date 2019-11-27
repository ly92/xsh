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
    
    
    
    fileprivate var selectedPayWay1 = JSON()//选择的互斥支付方式
    fileprivate var selectedPayWay2 : [String : JSON] = [:]//选择的互补支付方式
    fileprivate var selectedCoupon = JSON()//使用的优惠券
    fileprivate var payWayArray1 : Array<JSON> = []//可用互斥支付方式
    fileprivate var payWayArray2 : Array<JSON> = []//可用互补支付方式
    fileprivate var couponList : Array<JSON> = []//可用优惠券
    fileprivate var productionList : Array<JSON> = []//订单中的商品
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "支付"
        
        self.tableView.register(UINib.init(nibName: "PayWayCell", bundle: Bundle.main), forCellReuseIdentifier: "PayWayCell")
        self.tableView.register(UINib.init(nibName: "PayWayCell", bundle: Bundle.main), forCellReuseIdentifier: "PayWayCell-coupon")
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
            
            for json in result["couponList"].arrayValue{
                self.couponList.append(json)
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
        let dict = self.getTotalMoney()
        params["pointsMoney"] = dict["points"]
        params["money"] = dict["money"]
        
        if self.selectedPayWay1["atid"].stringValue.isEmpty && CGFloat(dict["money"]!) > 0{
            LYProgressHUD.showError("请选择支付方式！")
            return
        }
        
        params["ptid"] = self.selectedPayWay1["ptid"].stringValue
        params["atid"] = self.selectedPayWay1["atid"].stringValue
        params["destaccount"] = self.selectedPayWay1["destaccount"].stringValue
        params["orgaccount"] = self.selectedPayWay1["orgaccount"].stringValue
        
        if CGFloat(dict["money"]!) == 0{
            if self.selectedPayWay2.keys.contains("98"){
                //积分抵扣了所有钱，特殊处理
                let point = self.selectedPayWay2["98"]
                params["ptid"] = point!["ptid"].stringValue
                params["atid"] = point!["atid"].stringValue
                params["destaccount"] = point!["destaccount"].stringValue
                params["orgaccount"] = point!["orgaccount"].stringValue
            }else{
                //优惠券抵消了所有的钱
                //1.优先使用积分的参数
                var havePoint = false
                for json in self.payWayArray2{
                    if json["atid"].intValue == 98{
                        havePoint = true
                        params["ptid"] = json["ptid"].stringValue
                        params["atid"] = json["atid"].stringValue
                        params["destaccount"] = json["destaccount"].stringValue
                        params["orgaccount"] = json["orgaccount"].stringValue
                    }
                }
                //2.没有积分的参数就用一卡通的参数
                if !havePoint{
                    for json in self.payWayArray1{
                        if json["atid"].intValue == 94{
                            params["ptid"] = json["ptid"].stringValue
                            params["atid"] = json["atid"].stringValue
                            params["destaccount"] = json["destaccount"].stringValue
                            params["orgaccount"] = json["orgaccount"].stringValue
                        }
                    }
                }
            }
        }
        
        params["orderno"] = self.orderNo
        params["couponid"] = self.selectedCoupon["id"].stringValue
        
        
        
        //ptid:支付方式,atid:货币ID,orgaccount:付款账户,destaccount:收款账户,orderno:订单号,money:付款金额,points:积分抵消费金额,coupon:使用优惠券，逗号分隔优惠券码
        NetTools.requestData(type: .post, urlString: PrePayOrderApi, parameters: params, succeed: { (result) in
            let type = result["payinfo"]["paytype"].stringValue
            if type == "alipay"{
                self.payByAli(result["payinfo"]["orderInfo"].stringValue)
            }else if type == "weixin"{
                self.payByWechat(result["payinfo"])
            }else{
                self.payByCard(result["payinfo"]["tno"].stringValue, dict["money"]!)
            }
            
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }

    //MARK:---优惠券，积分，抵扣，支付宝，微信，一卡通
    func getTotalMoney() -> [String : Float] {
        var dict : [String : Float] = ["points" : 0, "money" : 0]
        
        //除积分，优惠券外的抵扣
        var discount : Float = 0
        //可用积分
        var points : Float = 0
        for (key, value) in self.selectedPayWay2{
            if key == "98"{
                points = value["points"].floatValue
            }else{
                discount += value["money"].floatValue
            }
        }
        
        //相比积分抵扣优选优惠券
        var coupon : Float = 0
        if self.selectedCoupon["use_type"].intValue == 1{
            //特定商品数组
            var goodsList : Array<String> = []
            for str in self.selectedCoupon["pid_arr"].arrayValue{
                goodsList.append(str.stringValue)
            }
            var temp_coupon : Float = 0
            for json in self.productionList{
                if goodsList.contains(json["pid"].stringValue){
                    temp_coupon += json["total_price"].floatValue
                }
            }
            //优惠券可抵扣金额
            if temp_coupon > self.selectedCoupon["money"].floatValue{
                coupon = self.selectedCoupon["money"].floatValue
            }else{
                coupon = temp_coupon
            }
        }else{
            //全品类
            //其他抵扣不能完全抵消
            if self.money.floatValue - discount > 0{
                if self.money.floatValue - discount - self.selectedCoupon["money"].floatValue > 0{
                    coupon = self.selectedCoupon["money"].floatValue
                }else{
                    coupon = self.money.floatValue - discount
                }
            }
        }

        var use_points : Float = 0
        //如果优惠券和其他抵扣不能全部抵扣且选择使用积分，则积分继续j抵扣
        if self.selectedPayWay2.keys.contains("98"){
            if self.money.floatValue - discount - coupon > 0{
                //全部积分或者部分积分
                if self.money.floatValue - discount - coupon - points > 0{
                    use_points = points
                }else{
                    use_points = self.money.floatValue - discount - coupon
                }
            }
            
        }
        
        //优惠券
        dict["coupon"] = coupon
        //积分
        dict["points"] = use_points
        
        //应支付的钱
        if self.money.floatValue - discount - coupon - use_points > 0{
            dict["money"] = self.money.floatValue - discount - coupon - use_points
        }else{
            dict["money"] = 0
        }
        
        return dict
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
            self.cancelOrder()
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
    func payByCard(_ tno : String, _ money : Float) {
        
        func pay(_ pwd : String){
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
                LYAlertView.show("提示", "支付失败，请重试！", "放弃", "重试", {
                    self.payByCard(tno, money)
                },{
                    if self.payResultBlock != nil{
                        self.payResultBlock!(3)
                    }
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
        
        
        if (money > 0){
            let pwdView = PayPasswordView()
            pwdView.parentVC = self
            pwdView.show { (pwd) in
                pay(pwd)
            }
        }else{
            pay("")
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
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 3 || section == 4{
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
                    if json["atid"].stringValue == "98"{
                        let dict = self.getTotalMoney()
                        cell3.selectedBtn.isSelected = true
//                        cell3.useLbl.text = "-¥" + String.init(format: "%.2f", dict["points"]!)
                        cell3.useLbl.text = "-" + String.init(format: "%.2f", dict["points"]!)
                    }else{
                        cell3.selectedBtn.isSelected = true
//                        cell3.useLbl.text = "-¥" + json["money"].stringValue
                        cell3.useLbl.text = "-" + json["money"].stringValue
                    }
                    
                }else{
                    cell3.selectedBtn.isSelected = false
                    cell3.useLbl.text = ""
                }
            }
            return cell3
        }else if indexPath.section == 3{
            //优惠券
            let cell = tableView.dequeueReusableCell(withIdentifier: "PayWayCell-coupon", for: indexPath) as! PayWayCell
           cell.imgV.image = UIImage.init(named: "pay_coupon")
            cell.titleLbl.text = "优惠券"
            cell.canUseLbl.text = "(可用\(self.couponList.count)张)"
            if self.selectedCoupon["money"].floatValue > 0{
                let dict = self.getTotalMoney()
//                cell.useLbl.text = "-¥" + String.init(format: "%.2f", dict["coupon"]!)
                cell.useLbl.text = "-" + String.init(format: "%.2f", dict["coupon"]!)
            }else{
                cell.useLbl.text = ""
            }
            
            cell.selectedBtn.setImage(UIImage.init(named: "right_arrow"), for: .normal)
            
            return cell
        }else if indexPath.section == 4{
            let cell4 = tableView.dequeueReusableCell(withIdentifier: "PayBtnCell", for: indexPath) as! PayBtnCell
            
            let dict = self.getTotalMoney()
            cell4.moneyLbl.text = String.init(format: "%.2f", dict["money"]!)
            
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
        }else if indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3{
            return 45
        }else if indexPath.section == 4{
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
            //选择优惠券
            let selectCouponVC = MyCouponTableViewController()
            selectCouponVC.isSelect = true
            selectCouponVC.couponList = self.couponList
            selectCouponVC.selectedCoupon = self.selectedCoupon
            selectCouponVC.selectBlock = {(coupon) in
                self.selectedCoupon = coupon ?? JSON()
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(selectCouponVC, animated: true)
        }else if indexPath.section == 4{
            self.prePayAction()
        }
    }
}
