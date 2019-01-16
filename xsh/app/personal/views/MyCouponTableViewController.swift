//
//  MyCouponTableViewController.swift
//  xsh
//
//  Created by ly on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyCouponTableViewController: BaseTableViewController {
    
    
    var isSelect = false
    
    fileprivate var couponList : Array<JSON> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isSelect{
            self.navigationItem.title = ""
        }else{
            self.navigationItem.title = "我的优惠券"
        }
        
        self.tableView.register(UINib.init(nibName: "CouponCell", bundle: Bundle.main), forCellReuseIdentifier: "CouponCell")
        
        self.loadMyCoupon()
        
    }
    
    //
    func loadMyCoupon() {
        var params : [String : Any] = [:]
        params["bixid"] = ""
        params["userid"] = LocalData.getCId()
        NetTools.requestData(type: .post, urlString: MyCouponListApi, parameters: params, succeed: { (result) in
            self.couponList = result["list"].arrayValue
            self.tableView.reloadData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.couponList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as! CouponCell
        if self.couponList.count > indexPath.row{
            cell.subJson = self.couponList[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
