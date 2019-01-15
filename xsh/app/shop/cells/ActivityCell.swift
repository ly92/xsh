//
//  ActivityCell.swift
//  xsh
//
//  Created by ly on 2018/12/18.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class ActivityCell: UICollectionViewCell {
    @IBOutlet weak var imgV: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var subJson = JSON(){
        didSet{
            self.imgV.setImageUrlStr(self.subJson["imageurl"].stringValue)
//            self.titleLbl.text = self.subJson["title"].stringValue
//            self.descLbl.text = self.subJson["title"].stringValue
        }
    }

}
