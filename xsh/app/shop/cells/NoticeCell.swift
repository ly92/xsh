//
//  NoticeCell.swift
//  xsh
//
//  Created by 李勇 on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var imgVW: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
