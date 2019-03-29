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
    
    var rule = JSON()
    var refreshBlock : (() -> Void)?
    
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

            self.stepLbl.text = "步数:" + self.subJson["steps"].stringValue
            //status 0未打卡 1可补卡 2已打卡 3已过期
            let status = self.subJson["status"].stringValue.intValue
            if status == 0{
                self.pointLeftLbl.text = "可兑换"
                if self.subJson["steps"].intValue >= self.rule["start_num"].intValue{
                    self.pointLbl.text = self.rule["fixed_points"].stringValue
                }else{
                    self.pointLbl.text = "0"
                }
                self.btn.setTitle("打卡", for: .normal)
                self.btn.backgroundColor = Normal_Color
            }else if status == 1{
                self.pointLeftLbl.text = "可兑换"
                if self.subJson["steps"].intValue >= self.rule["start_num"].intValue{
                    self.pointLbl.text = self.rule["fixed_points"].stringValue
                }else{
                    self.pointLbl.text = "0"
                }
                self.btn.setTitle("补卡", for: .normal)
                self.btn.backgroundColor = Normal_Color
            }else if status == 2{
                self.pointLeftLbl.text = "已兑换"
                self.pointLbl.text = self.subJson["points"].stringValue
                self.btn.setTitle("已打卡", for: .normal)
                self.btn.backgroundColor = UIColor.gray
            }else if status == 3{
                self.pointLeftLbl.text = "可兑换"
                self.pointLbl.text = self.subJson["points"].stringValue
                self.btn.setTitle("已过期", for: .normal)
                self.btn.backgroundColor = UIColor.RGBS(s: 200)
            }
        }
    }
    
    
    @IBAction func btnAction() {
        if self.subJson["status"].stringValue.intValue == 0 || self.subJson["status"].stringValue.intValue == 1{
            LYProgressHUD.showLoading()
            var params : [String : Any] = [:]
            params["steps"] = self.subJson["steps"].stringValue
            params["sign_date"] = Date.dateStringFromDate(format: Date.dateFormatString(), timeStamps: self.subJson["date"].stringValue)
            NetTools.requestData(type: .post, urlString: StepTransToPointApi, parameters: params, succeed: { (result) in
                LYProgressHUD.showSuccess("兑换成功！")
                self.pointLeftLbl.text = "已兑换"
                self.btn.setTitle("已打卡", for: .normal)
                if self.refreshBlock != nil{
                    self.refreshBlock!()
                }
            }) { (error) in
                LYProgressHUD.showError(error)
            }
        }
    }
    
}

/**
 var subJson = JSON(){
 didSet{
 self.timeLbl.text = Date.dateStringFromDate(format: Date.dateFormatString(), timeStamps: self.subJson["date"].stringValue)
 
 self.stepLbl.text = "步数:" + self.subJson["steps"].stringValue
 var part_num : Int = 1
 if self.rule["part_num"].intValue > 1{
 part_num = self.rule["part_num"].intValue
 }
 
 //status 0未打卡 1可补卡 2已打卡 3已过期
 let status = self.subJson["status"].stringValue.intValue
 if status == 0{
 let steps = self.subJson["steps"].intValue
 var point = (steps - self.rule["start_num"].intValue) / part_num
 if point > self.rule["max_points"].intValue{
 point = self.rule["max_points"].intValue
 }else if point < 0 {
 point = 0
 }
 
 self.pointLeftLbl.text = "可兑换"
 self.pointLbl.text = "\(point)"
 self.btn.setTitle("打卡", for: .normal)
 self.btn.backgroundColor = Normal_Color
 }else if status == 1{
 let steps = self.subJson["steps"].intValue
 var point = (steps - self.rule["start_num"].intValue) / part_num
 if point > self.rule["max_points"].intValue{
 point = self.rule["max_points"].intValue
 }else if point < 0 {
 point = 0
 }
 
 self.pointLeftLbl.text = "可兑换"
 self.pointLbl.text = "\(point)"
 self.btn.setTitle("补卡", for: .normal)
 self.btn.backgroundColor = Normal_Color
 }else if status == 2{
 self.pointLeftLbl.text = "已兑换"
 self.pointLbl.text = self.subJson["points"].stringValue
 self.btn.setTitle("已打卡", for: .normal)
 self.btn.backgroundColor = UIColor.gray
 }else if status == 3{
 self.pointLeftLbl.text = "可兑换"
 self.pointLbl.text = self.subJson["points"].stringValue
 self.btn.setTitle("已过期", for: .normal)
 self.btn.backgroundColor = UIColor.RGBS(s: 200)
 }
 }
 }
 */
