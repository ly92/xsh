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
    fileprivate var haveMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "交易记录"
        
        self.tableView.register(UINib.init(nibName: "MyOrderCell", bundle: Bundle.main), forCellReuseIdentifier: "MyOrderCell")
        
        if self.orderType == 1{
            self.loadShopOrder()
            self.tableView.separatorStyle = .none
        }else if self.orderType == 2{
            self.loadCardOrder()
        }
        
        
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
    
    
    //加载一卡通消费记录
    func loadCardOrder() {
        var params : [String : Any] = [:]
        params["starttime"] = ""
        params["stoptime"] = ""
        params["skip"] = self.shopOrderList.count
        params["limit"] = 10
        NetTools.requestData(type: .post, urlString: CardOrderListApi, parameters: params, succeed: { (result) in
            if result["list"].arrayValue.count < 10{
                self.haveMore = false
            }else{
                self.haveMore = true
            }
            for json in result["list"].arrayValue{
                self.cardOrderList.append(json)
            }
            
            if self.cardOrderList.count > 0{
                self.hideEmptyView()
                self.tableView.reloadData()
            }else{
                self.showEmptyView(frame: self.tableView.frame) {
                    self.loadCardOrder()
                }
            }
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    //加载商家消费订单
    func loadShopOrder() {
        NetTools.requestData(type: .post, urlString: CardTransactionListApi, succeed: { (result) in
            if result["list"].arrayValue.count < 10{
                self.haveMore = false
            }else{
                self.haveMore = true
            }
            for json in result["list"].arrayValue{
                self.shopOrderList.append(json)
            }
            if self.shopOrderList.count > 0{
                self.hideEmptyView()
                self.tableView.reloadData()
            }else{
                self.showEmptyView(frame: self.tableView.frame) {
                    self.loadShopOrder()
                }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
        
        if self.orderType == 1{
            if self.shopOrderList.count > 0{
                let json = self.shopOrderList[indexPath.row]
                cell.subJson = json
            }
        }else if self.orderType == 2{
            if self.cardOrderList.count > indexPath.row{
                let json = self.cardOrderList[indexPath.row]
                cell.subJson2 = json
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.orderType == 1{
            if self.shopOrderList.count > 0{
                let json = self.shopOrderList[indexPath.row]
                let detailVC = OrderDetailViewController()
                detailVC.orderno = json["orderno"].stringValue
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }else if self.orderType == 2{
//            if self.cardOrderList.count > indexPath.row{
//                let json = self.cardOrderList[indexPath.row]
//                let billdetailVC = BillPayDetailViewController.spwan()
//                billdetailVC.orderno = json[""].stringValue
//                self.navigationController?.pushViewController(billdetailVC, animated: true)
//            }
        }
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if self.orderType == 1{
            if indexPath.row == self.shopOrderList.count - 1 && self.haveMore{
                self.loadShopOrder()
            }
        }else if self.orderType == 2{
            if indexPath.row == self.cardOrderList.count - 1 && self.haveMore{
                self.loadCardOrder()
            }
        }
    }
    
    
    
}
