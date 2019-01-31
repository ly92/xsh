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
            var pointM : Float = 0
            for point in self.subJson["points"].arrayValue{
                pointM += point["money"].floatValue
            }
            
            var couponM : Float = 0
            for coupon in self.subJson["coupon"].arrayValue{
                couponM += coupon["money"].floatValue
            }
            
            self.couponLbl.text = String.init(format: "-%.2f", couponM)
            self.pointLbl.text = String.init(format: "-%.2f", pointM)
            self.totalMoneyLbl.text = self.subJson["money"].stringValue
        }
    }
}
