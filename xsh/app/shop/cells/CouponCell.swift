//
//  CouponCell.swift
//  xsh
//
//  Created by 李勇 on 2018/12/18.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class CouponCell: UITableViewCell {
    @IBOutlet weak var moneyLbl: UILabel!
    @IBOutlet weak var limitLbl: UILabel!
    @IBOutlet weak var storeLbl: UILabel!
    @IBOutlet weak var pointLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var couponImgV: UIImageView!
    @IBOutlet weak var getScaleLbl: UILabel!
    @IBOutlet weak var getBtn: UIButton!
    @IBOutlet weak var selectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
