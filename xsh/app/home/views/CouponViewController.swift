//
//  CouponViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/12.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class CouponViewController: BaseTableViewController {

    fileprivate var couponList : Array<JSON> = []
    
    //是否为商家领券中心
    var isStore = false
    var bid = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib.init(nibName: "CouponGetCell", bundle: Bundle.main), forCellReuseIdentifier: "CouponGetCell")
        self.navigationItem.title = "领券中心"
        
        self.loadCouponData()
        
        self.pullToRefre {
            self.couponList.removeAll()
            self.loadCouponData()
        }
        
        //登录通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: KLoginSuccessNotiName), object: nil, queue: nil) { (noti) in
            
        }
    }
    
    //优惠券列表-领券中心
    func loadCouponData() {
        var params : [String : Any] = [:]
        params["limit"] = 10
        params["skip"] = self.couponList.count
        if self.isStore{
            params["type"] = "1"
            params["bid"] = self.bid
        }else{
            params["type"] = "0"
        }
        
        NetTools.requestData(type: .post, urlString: CouponListApi, parameters: params, succeed: { (result) in
            for json in result["list"].arrayValue{
                self.couponList.append(json)
            }
            if self.couponList.count > 0{
                self.hideEmptyView()
                self.tableView.reloadData()
            }else{
                self.showEmptyView(frame: self.tableView.frame) {
                    self.loadCouponData()
                }
            }
            
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }

}


extension CouponViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.couponList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponGetCell", for: indexPath) as! CouponGetCell
        if self.couponList.count > indexPath.row{
            cell.subJson = self.couponList[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}
