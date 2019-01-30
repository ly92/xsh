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
    
    fileprivate var steps : Int = 0
    
    
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
            
            self.timeLbl.text = Date.dateStringFromDate(format: Date.dateFormatString(), timeStamps: self.subJson["date"].stringValue)
            
            let date = Date.init(timeIntervalSince1970: TimeInterval(self.subJson["date"].stringValue.intValue))
            
            //status 0未打卡 1可补卡 2已打卡 3已过期
            let status = self.subJson["status"].stringValue.intValue
            if status == 0{
                self.pointLeftLbl.text = "可兑换"
                HealthHelper.default.requestStep(date) { (steps) in
                    self.stepLbl.text = "步数:\(steps)"
                    self.pointLbl.text = "\(steps)"
                    self.steps = steps
                }
                self.btn.setTitle("打卡", for: .normal)
                self.btn.backgroundColor = Normal_Color
            }else if status == 1{
                self.pointLeftLbl.text = "可兑换"
                HealthHelper.default.requestStep(date) { (steps) in
                    self.stepLbl.text = "步数:\(steps)"
                    self.pointLbl.text = "\(steps)"
                    self.steps = steps
                }
                self.btn.setTitle("补卡", for: .normal)
                self.btn.backgroundColor = Normal_Color
            }else if status == 2{
                self.pointLeftLbl.text = "已兑换"
                self.pointLbl.text = self.subJson["points"].stringValue
                self.stepLbl.text = "步数:" + self.subJson["steps"].stringValue
                self.btn.setTitle("已打卡", for: .normal)
                self.btn.backgroundColor = UIColor.gray
            }else if status == 3{
                self.pointLeftLbl.text = "可兑换"
                self.pointLbl.text = "0"
                self.stepLbl.text = "步数:0"
                self.btn.setTitle("已过期", for: .normal)
                self.btn.backgroundColor = UIColor.gray
            }
        }
    }
    
    
    @IBAction func btnAction() {
        if self.subJson["status"].stringValue.intValue == 0 || self.subJson["status"].stringValue.intValue == 1{
            var params : [String : Any] = [:]
            params["steps"] = self.steps
            params["sign_date"] = Date.dateStringFromDate(format: Date.dateFormatString(), timeStamps: self.subJson["date"].stringValue)
            NetTools.requestData(type: .post, urlString: StepTransToPointApi, parameters: params, succeed: { (result) in
                LYProgressHUD.showSuccess("转换成功！")
            }) { (error) in
                LYProgressHUD.showError(error)
            }
        }
    }
    
}
