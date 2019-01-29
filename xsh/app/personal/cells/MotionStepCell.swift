//
//  MotionStepCell.swift
//  xsh
//
//  Created by 李勇 on 2019/1/29.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class MotionStepCell: UITableViewCell {

    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var pointLeftLbl: UILabel!
    @IBOutlet weak var pointLbl: UILabel!
    @IBOutlet weak var stepLbl: UILabel!
    @IBOutlet weak var btn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.btn.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var subJson = JSON(){
        didSet{
            self.timeLbl.text = Date.dateStringFromDate(format: Date.dayFormatString(), timeStamps: self.subJson["date"].stringValue)
            
            self.btn.setTitle("", for: .normal)
            //status 0未打卡 1可补卡 2已打卡 3已过期
            let status = self.subJson["status"].stringValue.intValue
            if status == 0{
                
            }else if status == 1{
                
            }else if status == 2{
                self.pointLeftLbl.text = "已兑换"
                self.pointLbl.text = self.subJson["points"].stringValue
                self.stepLbl.text = "步数:" + self.subJson["steps"].stringValue
            }else if status == 3{
                
            }
        }
    }
    
    @IBAction func btnAction() {
    }
    
}
