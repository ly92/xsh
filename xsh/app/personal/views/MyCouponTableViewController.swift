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
    var bizid = ""//商家ID
    var selectBlock : ((JSON) -> Void)?
    fileprivate var selectedCoupon : JSON? //使用的优惠券
    
    
    fileprivate var couponList : Array<JSON> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isSelect{
            self.navigationItem.title = "可用优惠券"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "确定", target: self, action: #selector(MyCouponTableViewController.rightItemAction))
        }else{
            self.navigationItem.title = "我的优惠券"
        }
        
        self.tableView.register(UINib.init(nibName: "CouponCell", bundle: Bundle.main), forCellReuseIdentifier: "CouponCell")
        
        self.loadMyCoupon()
        
    }
    
    //确定优惠券
    @objc func rightItemAction() {
        if self.selectedCoupon != nil{
            if self.selectBlock != nil{
                self.selectBlock!(self.selectedCoupon!)
            }
        }
    }
    
    
    //加载优惠券
    func loadMyCoupon() {
        var params : [String : Any] = [:]
        params["bizid"] = self.bizid
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
        return self.couponList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as! CouponCell
        if self.couponList.count > indexPath.row{
            let json = self.couponList[indexPath.row]
            cell.subJson = json
            if self.isSelect{
                cell.selectedBtn.isHidden = false
                cell.selectedBtn.isSelected = false
                if self.selectedCoupon != nil{
                    if self.selectedCoupon![""].stringValue == json[""].stringValue{
                        cell.selectedBtn.isSelected = true
                    }
                }
            }else{
                cell.selectedBtn.isHidden = true
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if self.isSelect{
            if self.couponList.count > indexPath.row{
                let json = self.couponList[indexPath.row]
                if self.selectedCoupon != nil{
                    if self.selectedCoupon![""].stringValue == json[""].stringValue{
                        self.selectedCoupon = nil
                    }else{
                        self.selectedCoupon = json
                    }
                }else{
                    self.selectedCoupon = json
                }
            }
            self.tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
