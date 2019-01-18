//
//  CouponCell.swift
//  xsh
//
//  Created by 李勇 on 2018/12/18.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class CouponCell: UITableViewCell {
    @IBOutlet weak var bgImgV: UIImageView!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var limitLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var couponIngV: UIImageView!
    @IBOutlet weak var pointLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var selectedBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.pointLbl.layer.cornerRadius = 2.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var subJson = JSON(){
        didSet{
            self.priceLbl.text = self.subJson["money"].stringValue
            self.limitLbl.text = "满" + self.subJson["intro"].stringValue + "可用"
            self.titleLbl.text = self.subJson["name"].stringValue
            self.descLbl.text = self.subJson["biz_name"].stringValue
           self.timeLbl.text = Date.dateStringFromDate(format: Date.timestampFormatString(), timeStamps: self.subJson["use_start_time"].stringValue) + " ~ " + Date.dateStringFromDate(format: Date.timestampFormatString(), timeStamps: self.subJson["use_end_time"].stringValue)
            self.couponIngV.setImageUrlStr(self.subJson["imageurl"].stringValue)
        }
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
}
