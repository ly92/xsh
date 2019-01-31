//
//  OrderGoodsCell.swift
//  xsh
//
//  Created by 李勇 on 2019/1/31.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class OrderGoodsCell: UITableViewCell {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    @IBOutlet weak var numLbl: UILabel!
    
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
            self.imgV.setImageUrlStr(self.subJson["picurl"].stringValue)
            self.nameLbl.text = self.subJson["title"].stringValue
            self.moneyLbl.text = self.subJson["price"].stringValue
            self.numLbl.text = "X" + self.subJson["amount"].stringValue
        }
    }
}
