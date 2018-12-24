//
//  PayBtnCell.swift
//  xsh
//
//  Created by ly on 2018/12/24.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class PayBtnCell: UITableViewCell {

    @IBOutlet weak var payBtn: UIButton!
    @IBOutlet weak var moneyLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.payBtn.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func payAction() {
    }
    
}
