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
            
        }) { (error) in
            LYProgressHUD.showError(error)
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
