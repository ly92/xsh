//
//  MyOrderTableViewController.swift
//  xsh
//
//  Created by ly on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyOrderTableViewController: BaseTableViewController {

    var orderType = 1 // 1:我的订单，2:一卡通消费记录
    
    fileprivate var shopOrderList : Array<JSON> = []
    fileprivate var cardOrderList : Array<JSON> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        
        self.tableView.register(UINib.init(nibName: "MyOrderCell", bundle: Bundle.main), forCellReuseIdentifier: "MyOrderCell")
        
        
        self.pullToRefre {
            if self.orderType == 1{
                self.shopOrderList.removeAll()
                self.loadShopOrder()
            }else if self.orderType == 2{
                self.cardOrderList.removeAll()
                self.loadCardOrder()
            }
        }
        
    }
    
    
    //加载商家消费订单
    func loadShopOrder() {
        var params : [String : Any] = [:]
        params["starttime"] = ""
        params["stoptime"] = ""
        params["skip"] = self.shopOrderList.count
        params["limit"] = 10
        NetTools.requestData(type: .post, urlString: ShopOrderListApi, succeed: { (result) in
            for json in result[""].arrayValue{
                self.shopOrderList.append(json)
                self.tableView.reloadData()
            }
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    //加载一卡通消费记录
    func loadCardOrder() {
        NetTools.requestData(type: .post, urlString: CardTransactionListApi, succeed: { (result) in
            for json in result[""].arrayValue{
                self.cardOrderList.append(json)
                self.tableView.reloadData()
            }
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.orderType == 1{
            return self.shopOrderList.count
        }else if self.orderType == 2{
            return self.cardOrderList.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.orderType == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
            return cell
        }else if self.orderType == 2{
            var cell = tableView.dequeueReusableCell(withIdentifier: "CardOrderCell")
            if cell == nil{
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "CardOrderCell")
            }
            return cell!
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.orderType == 1{
        }else if self.orderType == 2{
        }
        return 100
    }
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.noticeList.count - 1 && self.haveMore{
            if self.orderType == 1{
                self.loadShopOrder()
            }else if self.orderType == 2{
                self.loadCardOrder()
            }
        }
    }
}
