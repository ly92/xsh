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
    
    
    //加载商家消费订单
    func loadShopOrder() {
        var params : [String : Any] = [:]
        params["starttime"] = ""
        params["stoptime"] = Date.phpTimestamp()
        params["skip"] = self.shopOrderList.count
        params["limit"] = 10
        NetTools.requestData(type: .post, urlString: ShopOrderListApi, parameters: params, succeed: { (result) in
            if result["list"].arrayValue.count < 10{
                self.haveMore = false
            }else{
                self.haveMore = true
            }
            for json in result["list"].arrayValue{
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
            if result["list"].arrayValue.count < 10{
                self.haveMore = false
            }else{
                self.haveMore = true
            }
            for json in result["list"].arrayValue{
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
            if self.shopOrderList.count > 0{
                let json = self.shopOrderList[indexPath.row]
                cell.subJson = json
            }
            return cell
        }else if self.orderType == 2{
            var cell = tableView.dequeueReusableCell(withIdentifier: "CardOrderCell")
            if cell == nil{
                cell = UITableViewCell.init(style: .value1, reuseIdentifier: "CardOrderCell")
            }
            cell?.selectionStyle = .none
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
            cell?.textLabel?.textColor = UIColor.RGBS(s: 102)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 17.0)
            cell?.detailTextLabel?.textColor = UIColor.RGBS(s: 51)
            if self.cardOrderList.count > indexPath.row{
                let json = self.cardOrderList[indexPath.row]
                cell?.textLabel?.text = Date.dateStringFromDate(format: Date.timestampFormatString(), timeStamps: json["creationtime"].stringValue)
                cell?.detailTextLabel?.text = "¥" + json["money"].stringValue
            }
            
            return cell!
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.orderType == 1{
            return 100
        }else if self.orderType == 2{
            return 44
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.orderType == 1{
            if self.shopOrderList.count > 0{
                let json = self.shopOrderList[indexPath.row]
                
            }
        }else if self.orderType == 2{
            if self.cardOrderList.count > indexPath.row{
                let json = self.cardOrderList[indexPath.row]
                let billdetailVC = BillPayDetailViewController.spwan()
                billdetailVC.billJson = json
                self.navigationController?.pushViewController(billdetailVC, animated: true)
            }
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
