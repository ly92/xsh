//
//  ComplantCell.swift
//  xsh
//
//  Created by 李勇 on 2019/3/21.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class ComplantCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var statusImgV: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //status状态 0未处理，1已受理，2处理中，3已处理，4已完结
    //维修
    var subJson = JSON(){
        didSet{
            if self.subJson["maintype"].intValue == 1{
                self.nameLbl.text = "公共维修:" + self.subJson["id"].stringValue
            }else if self.subJson["maintype"].intValue == 2{
                self.nameLbl.text = "个人维修:" + self.subJson["id"].stringValue
            }else{
                
            }
            
            let status = self.subJson["status"].intValue + 1
            self.statusImgV.image = UIImage.init(named: "repair_status_\(status)")
            self.contentLbl.text = self.subJson["content"].stringValue
            self.timeLbl.text = Date.dateStringFromDate(format: Date.datesFormatString(), timeStamps: self.subJson["creationtime"].stringValue)
        }
    }
    
    //投诉建议
    var subJson2 = JSON(){
        didSet{
            if self.subJson2["type"].intValue == 1{
                self.nameLbl.text = "投诉:" + self.subJson2["id"].stringValue
            }else if self.subJson2["type"].intValue == 2{
                self.nameLbl.text = "建议:" + self.subJson2["id"].stringValue
            }else{
                
            }
            
            let status = self.subJson2["status"].intValue + 1
            self.statusImgV.image = UIImage.init(named: "repair_status_\(status)")
            self.contentLbl.text = self.subJson2["content"].stringValue
            self.timeLbl.text = Date.dateStringFromDate(format: Date.datesFormatString(), timeStamps: self.subJson2["creationtime"].stringValue)
        }
    }
    
}
