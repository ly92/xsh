//
//  OrderDetailCell.swift
//  xsh
//
//  Created by 李勇 on 2019/1/31.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderDetailCell: UITableViewCell {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var ordernoLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var payWayLbl: UILabel!
    @IBOutlet weak var payTimeLbl: UILabel!
    
    
    
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
            self.statusLbl.text = self.subJson["status"].stringValue
            self.ordernoLbl.text = self.subJson["orderno"].stringValue
            self.timeLbl.text = self.subJson["creationtime"].stringValue
            self.payTimeLbl.text = self.subJson["rejecttime"].stringValue
            self.payWayLbl.text = self.subJson["atid"].stringValue
        }
    }
    
}
