//
//  BillPayDetailViewController.swift
//  xsh
//
//  Created by ly on 2018/12/25.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class BillPayDetailViewController: BaseTableViewController {
    class func spwan() -> BillPayDetailViewController{
        return self.loadFromStoryBoard(storyBoard: "Message") as! BillPayDetailViewController
    }
    
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var resultLbl: UILabel!
    
    var billJson = JSON()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "缴费详情"
        
        self.addressLbl.text = self.billJson["memo"].stringValue
        self.timelbl.text = self.billJson["creationtime"].stringValue
        self.typeLbl.text = self.billJson["servicetype"].stringValue
        self.moneyLbl.text = "¥" + self.billJson["money"].stringValue
        self.phoneLbl.text = LocalData.getUserPhone()
        self.resultLbl.text = self.billJson["status"].stringValue
    }

    


    
}
