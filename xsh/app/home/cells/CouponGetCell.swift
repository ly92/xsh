//
//  CouponGetCell.swift
//  xsh
//
//  Created by 李勇 on 2019/1/9.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class CouponGetCell: UITableViewCell {
    
    @IBOutlet weak var cardLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var pointLbl: UILabel!
    @IBOutlet weak var overLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var getBtn: UIButton!
    @IBOutlet weak var imgV: UIImageView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.getBtn.layer.cornerRadius = 10
        self.pointLbl.layer.cornerRadius = 2.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func getAction() {
        if self.subJson["user_status"].stringValue.intValue == 1 || self.subJson["status"].stringValue.intValue != 0{
            return
        }
        var params : [String : Any] = [:]
        params["optid"] = self.subJson["optid"].stringValue
        params["userid"] = LocalData.getCId()
        NetTools.requestData(type: .post, urlString: CouponGetApi, parameters: params, succeed: { (result) in
            LYProgressHUD.showSuccess("领取成功！")
            self.getBtn.setTitle("已领取", for: .normal)
            self.getBtn.backgroundColor = UIColor.gray
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    var subJson = JSON(){
        didSet{
//            self.cardLbl.isHidden = false
            self.priceLbl.text = self.subJson["money"].stringValue
//            self.overLbl.text = "满" + self.subJson["intro"].stringValue + "可用"
            self.overLbl.text = ""
            self.titleLbl.text = self.subJson["name"].stringValue
            self.descLbl.text = self.subJson["biz_name"].stringValue
            self.nameLbl.text = self.subJson["intro"].stringValue
            let scal = self.subJson["cur_num"].stringValue.floatValue * 100 / self.subJson["remain_num"].stringValue.floatValue
            self.stateLbl.text = String.init(format: "已领取%.2f", scal) + "%"
            self.imgV.setImageUrlStr(self.subJson["imageurl"].stringValue)
            
            if self.subJson["user_status"].stringValue.intValue == 1{
                self.getBtn.setTitle("已领取", for: .normal)
                self.getBtn.backgroundColor = UIColor.gray
            }else{
                self.getBtn.setTitle("立即领取", for: .normal)
                if self.subJson["status"].stringValue.intValue == 0{
                    self.getBtn.backgroundColor = Normal_Color
                }else{
                    self.getBtn.backgroundColor = UIColor.gray
                }
            }
        }
    }
    
    
}
