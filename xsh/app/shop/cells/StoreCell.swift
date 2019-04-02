//
//  StoreCell.swift
//  xsh
//
//  Created by ly on 2019/1/17.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class StoreCell: UITableViewCell {
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var disLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    var subJson = JSON(){
        didSet{
            self.imgV.setImageUrlStr(self.subJson["logourl"].stringValue)
            self.nameLbl.text = self.subJson["name"].stringValue
            self.addressLbl.text = self.subJson["industry_name"].stringValue
            self.disLbl.text = "\(self.subJson["distance"].stringValue.intValue)米"
            self.descLbl.text = self.subJson["address"].stringValue
        }
    }
    
}
