//
//  PayWayCell.swift
//  xsh
//
//  Created by ly on 2018/12/24.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class PayWayCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var canUseLbl: UILabel!
    @IBOutlet weak var useLbl: UILabel!
    @IBOutlet weak var selectedBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     atid
     94：一卡通
     98：积分
     102：微信
     103：支付宝
     */
    var subJson = JSON(){
        didSet{
            self.imgV.setImageUrlStr(self.subJson["icon"].stringValue)
            self.titleLbl.text = self.subJson["name"].stringValue
            if self.subJson["atid"].intValue == 94 || self.subJson["atid"].intValue == 98{
                self.canUseLbl.text = "(" + self.subJson["money"].stringValue + ")"
            }else{
                self.canUseLbl.text = ""
                self.useLbl.text = ""
            }
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
    
}
