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
    
    var orderNo = ""
    
    fileprivate var payTypeJson = JSON()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "支付"

    }
    
    
    
    //支付方式
    func getPayWay() {
        let params : [String : Any] = ["orderno" : self.orderNo]
        NetTools.requestData(type: .post, urlString: PayTypeApi, parameters: params, succeed: { (result) in
            self.payTypeJson = result
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    //生成预付单
    func prePayAction() {
        var params : [String : Any] = [:]
        //ptid:支付方式,atid:货币ID,ano:收款账户,orderno:订单号,money:付款金额,points:积分抵消费金额,coupons:使用优惠券，逗号分隔优惠券码
        NetTools.requestData(type: .post, urlString: PrePayOrderApi, parameters: params, succeed: { (result) in
            
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }


    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    

}
