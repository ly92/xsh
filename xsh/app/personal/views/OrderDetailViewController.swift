//
//  OrderDetailViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/1/30.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON


class OrderDetailViewController: BaseTableViewController {

    var orderno = ""
    
    fileprivate var goodsList : Array<JSON> = []
    fileprivate var couponList : Array<JSON> = []
    fileprivate var orderInfo = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = BG_Color
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: "OrderDetailCell", bundle: Bundle.main), forCellReuseIdentifier: "OrderDetailCell")
        self.tableView.register(UINib.init(nibName: "OrderGoodsCell", bundle: Bundle.main), forCellReuseIdentifier: "OrderGoodsCell")
        self.tableView.register(UINib.init(nibName: "OrderPayInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "OrderPayInfoCell")
        self.tableView.register(UINib.init(nibName: "CouponCell", bundle: Bundle.main), forCellReuseIdentifier: "CouponCell")
        
        
        self.loadDetailData()
    }

    //加载详情
    func loadDetailData() {
        let params = ["orderno" : self.orderno]
        NetTools.requestData(type: .post, urlString: CardTransactionDetailApi, parameters: params, succeed: { (result) in
            self.orderInfo = result
            self.goodsList = result["transaction"]["orderItems"].arrayValue
            self.couponList = result["coupon"].arrayValue
            self.tableView.reloadData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 2{
            return 1
        }else if section == 1{
            return self.goodsList.count
        }else if section == 3{
            return self.couponList.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailCell", for: indexPath) as! OrderDetailCell
            cell.subJson = self.orderInfo
            return cell
        }else if indexPath.section == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderGoodsCell", for: indexPath) as! OrderGoodsCell
            if self.goodsList.count > indexPath.row{
                let json = self.goodsList[indexPath.row]
                cell.subJson = json
            }
            return cell
        }else if indexPath.section == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderPayInfoCell", for: indexPath) as! OrderPayInfoCell
            cell.subJson = self.orderInfo
            return cell
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as! CouponCell
            if self.couponList.count > indexPath.row{
                let json = self.couponList[indexPath.row]
                cell.subJson = json
                cell.timeLbl.text = "已使用"
            }
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 200
        }else if indexPath.section == 1{
            return 60
        }else if indexPath.section == 2{
            return 135
        }else if indexPath.section == 3{
            return 120
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 2{
            return nil
        }
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: 50))
        view.backgroundColor = BG_Color
        let subView = UIView.init(frame: CGRect.init(x: 10, y: 8, width: kScreenW - 20, height: 42))
        subView.backgroundColor = UIColor.white
        view.addSubview(subView)
        let lbl = UILabel.init(frame: CGRect.init(x: 8, y: 10, width: kScreenW - 36, height: 21))
        lbl.font = UIFont.systemFont(ofSize: 14.0)
        lbl.textColor = UIColor.colorHex(hex: "666666")
        
        if section == 1{
            lbl.text = "商品信息"
            if self.goodsList.count > 0{
                return view
            }
        }else if section == 3{
            lbl.text = "优惠券信息"
            if self.couponList.count > 0{
                return view
            }
            return view
        }
        return nil
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            if self.goodsList.count > 0{
                return 50
            }
        }else if section == 3{
            if self.couponList.count > 0{
                return 50
            }
        }
        return 0.001
    }

}
