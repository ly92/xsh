//
//  EvaluateOrderGoodsCell.swift
//  xsh
//
//  Created by 李勇 on 2019/3/26.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class EvaluateOrderGoodsCell: UITableViewCell {

    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var start1: UIButton!
    @IBOutlet weak var start2: UIButton!
    @IBOutlet weak var start3: UIButton!
    @IBOutlet weak var start4: UIButton!
    @IBOutlet weak var start5: UIButton!
    
    var startBlock : ((Int, Int) -> Void)?
    
    fileprivate var btnArray : Array<UIButton> = []
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.btnArray.append(start1)
        self.btnArray.append(start2)
        self.btnArray.append(start3)
        self.btnArray.append(start4)
        self.btnArray.append(start5)
        
    }
    
    var subJson = JSON(){
        didSet{
            self.imgV.setImageUrlStr(self.subJson["picurl"].stringValue)
            self.nameLbl.text = self.subJson["title"].stringValue
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        for btn in self.btnArray{
            if btn.tag > sender.tag{
                btn.setImage(UIImage.init(named: "start_1"), for: .normal)
            }else{
                btn.setImage(UIImage.init(named: "start_2"), for: .normal)
            }
        }
        
        if self.startBlock != nil{
            self.startBlock!(self.subJson["pid"].intValue, sender.tag)
        }
    }
    
    
}
