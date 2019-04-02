//
//  OrderPayInfoCell.swift
//  xsh
//
//  Created by 李勇 on 2019/1/31.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderPayInfoCell: UITableViewCell {
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var couponLbl: UILabel!
    @IBOutlet weak var pointLbl: UILabel!
    @IBOutlet weak var totalMoneyLbl: UILabel!
    @IBOutlet weak var orderMoneyLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var subJson = JSON(){
        didSet{
//            self.couponLbl.text = "-¥" + self.subJson["coupon_coupontaxmoney"].stringValue
//            self.pointLbl.text = "-¥" + self.subJson["points_money"].stringValue
//            self.totalMoneyLbl.text = "¥" + self.subJson["totalprice"].stringValue
//            self.orderMoneyLbl.text = "¥" + self.subJson["money"].stringValue
            self.couponLbl.text = "-" + self.subJson["coupon_coupontaxmoney"].stringValue
            self.pointLbl.text = "-" + self.subJson["points_money"].stringValue
            self.totalMoneyLbl.text = self.subJson["totalprice"].stringValue
            self.orderMoneyLbl.text = self.subJson["money"].stringValue
        }
    }
}
