//
//  CouponDetailViewController.swift
//  xsh
//
//  Created by ly on 2019/1/17.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class CouponDetailViewController: BaseViewController {
    class func spwan() -> CouponDetailViewController{
        return self.loadFromStoryBoard(storyBoard: "Home") as! CouponDetailViewController
    }
    
    var couponId = ""
    
    
    @IBOutlet weak var numLbl: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    @IBOutlet weak var limitLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var storeList : Array<JSON> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "优惠券详情"
        self.tableView.register(UINib.init(nibName: "CouponStoreCell", bundle: Bundle.main), forCellReuseIdentifier: "CouponStoreCell")
        
        self.loadDetailData()
    }
    

    
    //优惠券详情
    func loadDetailData() {
        let params : [String : Any] = ["id" : self.couponId]
        NetTools.requestData(type: .post, urlString: CouponDetailApi, parameters: params, succeed: { (result) in
            
            self.numLbl.text = result["sncode"].stringValue
            self.moneyLbl.text = result["money"].stringValue
            self.limitLbl.text = result[""].stringValue
            self.timeLbl.text = Date.dateStringFromDate(format: Date.timestampFormatString(), timeStamps: result["use_start_time"].stringValue) + " ~ " + Date.dateStringFromDate(format: Date.timestampFormatString(), timeStamps: result["use_end_time"].stringValue)
            
            
            self.storeList = result["biz"].arrayValue
            self.tableView.reloadData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }


}


extension CouponDetailViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponStoreCell", for: indexPath) as! CouponStoreCell
        if self.storeList.count > indexPath.row{
            let json = self.storeList[indexPath.row]
            cell.subJson = json
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.storeList.count > indexPath.row{
            let json = self.storeList[indexPath.row]
            let webVC = StoreViewController()
            let ts = Date.phpTimestamp()
            let cmdno = String.randomStr(len: 20) + ts
            let sign = (LocalData.getCId() + ts + cmdno + LocalData.getPwd()).md5String()
            let url = usedServer.replacingOccurrences(of: "app/", with: "") + "shopping/index.html?bid=" + json["bid"].stringValue + "&cid=" + LocalData.getCId() + "&ts=" + ts + "&sign=" + sign + "&cmdno=" + cmdno + "&productionId=" + json["productionId"].stringValue
            webVC.urlStr = url
            webVC.bid = json["bid"].stringValue
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
}
