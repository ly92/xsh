//
//  MessageCell.swift
//  xsh
//
//  Created by 李勇 on 2018/12/23.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessageCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var selectImgV: UIImageView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var subJson = JSON(){
        didSet{
            let type = self.subJson["type"].stringValue.trim
            if type == "trans"{
                self.titleLbl.text = "交易通知"
                self.imgV.image = UIImage.init(named: "message_icon1")
            }else if type == "coupon"{
                self.titleLbl.text = "领券通知"
                self.imgV.image = UIImage.init(named: "message_icon2")
            }else if type == "pay"{
                self.titleLbl.text = "缴费通知"
                self.imgV.image = UIImage.init(named: "message_icon1")
            }else if type == "advice"{
                self.titleLbl.text = "投诉建议通知"
                self.imgV.image = UIImage.init(named: "message_icon3")
            }else if type == "maintain"{
                self.titleLbl.text = "维修通知"
                self.imgV.image = UIImage.init(named: "message_icon4")
            }else if type == "else"{
                self.titleLbl.text = "消息通知"
                self.imgV.image = UIImage.init(named: "message_icon5")
            }else{
                self.titleLbl.text = "消息通知"
                self.imgV.image = UIImage.init(named: "message_icon5")
            }
            self.descLbl.text = self.subJson["title"].stringValue
            
            
            self.timeLbl.text = Date.dateStringFromDate(format: Date.datesPointFormatString(), timeStamps: self.subJson["creationtime"].stringValue)
        }
    }
}

