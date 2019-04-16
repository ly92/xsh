//
//  OrderDetailViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/1/30.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON


class OrderDetailViewController: BaseViewController {

    var orderno = ""
    
    fileprivate var goodsList : Array<JSON> = []
    fileprivate var orderInfo = JSON()
    fileprivate var tableView = UITableView()
    fileprivate var evaluateBtn = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpUI()
        self.navigationItem.title = "订单详情"
        
        self.loadDetailData()
    }
    
    //布局
    func setUpUI() {
        
        self.view.addSubview(self.evaluateBtn)
        self.view.addSubview(self.tableView)
        
        self.evaluateBtn.addTarget(self, action: #selector(OrderDetailViewController.evaluateAction), for: .touchUpInside)
        self.evaluateBtn.setTitle("评价", for: .normal)
        self.evaluateBtn.backgroundColor = UIColor.white
        self.evaluateBtn.setTitleColor(Normal_Color, for: .normal)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = BG_Color
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: "OrderDetailCell", bundle: Bundle.main), forCellReuseIdentifier: "OrderDetailCell")
        self.tableView.register(UINib.init(nibName: "OrderGoodsCell", bundle: Bundle.main), forCellReuseIdentifier: "OrderGoodsCell")
        self.tableView.register(UINib.init(nibName: "OrderPayInfoCell", bundle: Bundle.main), forCellReuseIdentifier: "OrderPayInfoCell")
        self.tableView.register(UINib.init(nibName: "CouponCell", bundle: Bundle.main), forCellReuseIdentifier: "CouponCell")
        
        self.evaluateBtn.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(0)
            make.height.equalTo(50)
        }
        self.tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(0)
            make.bottom.equalTo(self.evaluateBtn.snp.top)
        }
    }
    
    
    @objc func evaluateAction() {
        let evaluateVC = EvaluateOrderViewController()
        evaluateVC.goodsList = self.goodsList
        evaluateVC.orderno = self.orderno
        evaluateVC.evaluateSuccessBlock = {() in
            self.loadDetailData()
        }
        self.navigationController?.pushViewController(evaluateVC, animated: true)
    }

    //加载详情
    func loadDetailData() {
        let params = ["orderno" : self.orderno]
        NetTools.requestData(type: .post, urlString: CardTransactionDetailApi, parameters: params, succeed: { (result) in
            self.orderInfo = result["transaction"]
            self.goodsList = result["transaction"]["orderItems"].arrayValue
            
            //没有商品的隐藏评价按钮
            if self.goodsList.count == 0 || result["transaction"]["has_evaluate"].intValue == 1 || result["transaction"]["status"].stringValue != "已完成"{
                self.evaluateBtn.snp.makeConstraints { (make) in
                    make.bottom.leading.trailing.equalTo(0)
                    make.height.equalTo(0)
                }
                self.tableView.snp.makeConstraints { (make) in
                    make.top.leading.trailing.equalTo(0)
                    make.bottom.equalTo(self.evaluateBtn.snp.top)
                }
            }
            
            self.tableView.reloadData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
}

extension OrderDetailViewController : UITableViewDelegate, UITableViewDataSource{
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 2{
            return 1
        }else if section == 1{
            return self.goodsList.count
        }else if section == 3{
            if self.orderInfo["coupon_couponid"].intValue > 0{
                return 1
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            cell.priceLbl.text = self.orderInfo["coupon_couponmoney"].stringValue
            cell.titleLbl.text = self.orderInfo["coupon_name"].stringValue
            cell.descLbl.text = self.orderInfo["coupon_intro"].stringValue
            cell.couponIngV.setImageUrlStr(self.orderInfo["coupon_imageurl"].stringValue)
            cell.timeLbl.text = "已使用"
            cell.selectedBtn.isHidden = true
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 200
        }else if indexPath.section == 1{
            return 60
        }else if indexPath.section == 2{
            return 160
        }else if indexPath.section == 3{
            return 120
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 || section == 2 || section == 3{
            return nil
        }
        
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: 35))
        view.backgroundColor = BG_Color
        let subView = UIView.init(frame: CGRect.init(x: 10, y: 0, width: kScreenW - 20, height: 34))
        subView.backgroundColor = UIColor.white
        subView.clipsToBounds = true
        subView.layer.cornerRadius = 5
        view.addSubview(subView)
        let lbl = UILabel.init(frame: CGRect.init(x: 8, y: 10, width: kScreenW - 36, height: 18))
        lbl.font = UIFont.systemFont(ofSize: 15.0)
        lbl.textColor = UIColor.RGBS(s: 53)
        subView.addSubview(lbl)
        
        if section == 1{
            lbl.text = "商品信息"
            if self.goodsList.count > 0{
                return view
            }
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1{
            if self.goodsList.count > 0{
                return 35
            }
        }
        return 0.001
    }
}
