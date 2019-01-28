//
//  CouponStoreCell.swift
//  xsh
//
//  Created by ly on 2019/1/17.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class CouponStoreCell: UITableViewCell {
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var useBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.useBtn.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var subJson = JSON(){
        didSet{
            self.imgV.setImageUrlStr(self.subJson["logourl"].stringValue)
            self.nameLbl.text = self.subJson["name"].stringValue
            self.addressLbl.text = self.subJson["address"].stringValue
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
    
}
