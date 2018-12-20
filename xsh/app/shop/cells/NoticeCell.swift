//
//  NoticeCell.swift
//  xsh
//
//  Created by 李勇 on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class NoticeCell: UITableViewCell {
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var imgVW: NSLayoutConstraint!
    
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
            self.timeLb.text = Date.dateStringFromDate(format: Date.dateChineseFormatString(), timeStamps: self.subJson["creationtime"].stringValue)
            self.titleLbl.text = self.subJson["title"].stringValue
            self.descLbl.text = self.subJson["content"].stringValue
            if self.subJson["thumb"].stringValue.isEmpty{
                self.imgVW.constant = 0
            }else{
                self.imgVW.constant = 75
                self.imgV.setImageUrlStr(self.subJson["thumb"].stringValue)
            }
            
            
        }
    }
    
}
