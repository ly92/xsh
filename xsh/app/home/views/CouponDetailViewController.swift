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
    @IBOutlet weak var useBtn: UIButton!
    
    fileprivate var storeList : Array<JSON> = []
    fileprivate var couponJson = JSON()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "优惠券详情"
        self.tableView.register(UINib.init(nibName: "CouponStoreCell", bundle: Bundle.main), forCellReuseIdentifier: "CouponStoreCell")
        
        self.useBtn.layer.cornerRadius = 5
        
        self.loadDetailData()
    }
    

    
    //优惠券详情
    func loadDetailData() {
        let params : [String : Any] = ["id" : self.couponId]
        NetTools.requestData(type: .post, urlString: CouponDetailApi, parameters: params, succeed: { (result) in
            
            self.couponJson = result
            
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
    
    //展示二维码
    @IBAction func useCouponAction() {
        let codeView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH))
        codeView.backgroundColor = UIColor.white
        let codeImgV = UIImageView.init(frame: CGRect.init(x: kScreenW / 2.0 - 125, y: kScreenH / 2.0 - 125, width: 250, height: 250))
        codeImgV.image = UIImageView.createQrcode(self.couponJson["sncode"].stringValue)
        codeView.addSubview(codeImgV)
        
        AppDelegate.sharedInstance.window?.addSubview(codeView)
        
        codeView.addTapActionBlock {
            codeView.removeFromSuperview()
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
