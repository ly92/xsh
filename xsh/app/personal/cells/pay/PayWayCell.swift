//
//  PayWayCell.swift
//  xsh
//
//  Created by ly on 2018/12/24.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class PayWayCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var canUseLbl: UILabel!
    @IBOutlet weak var useLbl: UILabel!
    @IBOutlet weak var selectedBtn: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
