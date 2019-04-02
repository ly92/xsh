//
//  MyOrderCell.swift
//  xsh
//
//  Created by 李勇 on 2018/12/18.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyOrderCell: UITableViewCell {
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    
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
            self.nameLbl.text = self.subJson["servicetype"].stringValue
            self.timeLbl.text = self.subJson["creationtime"].stringValue
            self.moneyLbl.text = self.subJson["totalprice"].stringValue
//            self.moneyLbl.text = "¥" + self.subJson["totalprice"].stringValue
        }
    }
    
    var subJson2 = JSON(){
        didSet{
            self.nameLbl.text = self.subJson2["content"].stringValue
            self.timeLbl.text = self.subJson2["creationtime"].stringValue
//            self.moneyLbl.text = "¥" + self.subJson2["money"].stringValue
            self.moneyLbl.text = self.subJson2["money"].stringValue
        }
    }
    
}
