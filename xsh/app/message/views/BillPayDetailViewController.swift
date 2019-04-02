//
//  BillPayDetailViewController.swift
//  xsh
//
//  Created by ly on 2018/12/25.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class BillPayDetailViewController: BaseTableViewController {
    class func spwan() -> BillPayDetailViewController{
        return self.loadFromStoryBoard(storyBoard: "Message") as! BillPayDetailViewController
    }
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var resultLbl: UILabel!
    
    
    var orderno = ""
    var uuid = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "缴费详情"
        
        self.loadOrderDetail()
    }

    //获取详情数据
    func loadOrderDetail() {
        var params : [String : Any] = [:]
        params["orderno"] = self.orderno
        params["UUID"] = self.uuid
        NetTools.requestData(type: .post, urlString: PayOrderDetailApi, parameters: params, succeed: { (result) in
            
            self.addressLbl.text = result["payInfo"]["HouseAddress"].stringValue
            self.timelbl.text = result["payInfo"]["order_creationtime"].stringValue
            self.typeLbl.text = result["payInfo"]["PayCategoryCodeName"].stringValue
            self.moneyLbl.text = result["payInfo"]["TotalMoney"].stringValue
//            self.moneyLbl.text = "¥" + result["payInfo"]["TotalMoney"].stringValue
            self.phoneLbl.text = result["payInfo"]["MobileNo"].stringValue
            self.resultLbl.text = result["payInfo"]["StatusCodeName"].stringValue
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }


    
}
