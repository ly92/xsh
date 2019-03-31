//
//  RecommendGoodsCell.swift
//  xsh
//
//  Created by 李勇 on 2019/1/16.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class RecommendGoodsCell: UICollectionViewCell {
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.subView.layer.cornerRadius = 3
    }
    
    var subJson = JSON(){
        didSet{
            self.imgV.setImageUrlStr(self.subJson["picurl"].stringValue)
//            self.titleLbl.text = self.subJson["title"].stringValue
            self.titleLbl.text = self.subJson["recommend"].stringValue
            self.priceLbl.text = self.subJson["price"].stringValue
            self.unitLbl.text = self.subJson["unit"].stringValue
            self.countLbl.text = "销量：" + self.subJson["salecount"].stringValue
//                + self.subJson["unit"].stringValue
        }
    }

}
