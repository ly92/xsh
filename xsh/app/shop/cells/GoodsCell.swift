//
//  GoodsCell.swift
//  xsh
//
//  Created by ly on 2018/12/18.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class GoodsCell: UITableViewCell {
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var saleCountLbl: UILabel!
    
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
            self.imgV.setImageUrlStr(self.subJson["picurl"].stringValue)
            self.nameLbl.text = self.subJson["title"].stringValue
            self.descLbl.text = self.subJson["recommend"].stringValue
            self.priceLbl.text = self.subJson["price"].stringValue
            self.saleCountLbl.text = "已卖出" + self.subJson["salecount"].stringValue + self.subJson["unit"].stringValue
        }
    }
    
}
