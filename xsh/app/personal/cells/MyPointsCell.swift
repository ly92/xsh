//
//  MyPointsCell.swift
//  xsh
//
//  Created by 李勇 on 2019/4/7.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyPointsCell: UITableViewCell {
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var subJson = JSON(){
        didSet{
//            self.timeLbl.text = Date.dateStringFromDate(format: Date.dateChineseFormatString(), timeStamps: self.subJson["createtime"].stringValue)
            self.timeLbl.text = self.subJson["createtime"].stringValue
            self.descLbl.text = self.subJson["content"].stringValue
            self.pointsLbl.text = self.subJson["prefix"].stringValue + String.init(format: "%.2f", self.subJson["points"].doubleValue)
        }
    }
    
}
