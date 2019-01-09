//
//  CouponGetCell.swift
//  xsh
//
//  Created by 李勇 on 2019/1/9.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit

class CouponGetCell: UITableViewCell {
    
    @IBOutlet weak var cardLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var overLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var getBtn: UIButton!
    @IBOutlet weak var imgV: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func getAction() {
    }
    
    
    
}
