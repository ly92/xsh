//
//  MyOrderCell.swift
//  xsh
//
//  Created by 李勇 on 2018/12/18.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class MyOrderCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
