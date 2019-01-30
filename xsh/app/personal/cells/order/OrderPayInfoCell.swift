//
//  OrderPayInfoCell.swift
//  xsh
//
//  Created by 李勇 on 2019/1/31.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit

class OrderPayInfoCell: UITableViewCell {
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var couponLbl: UILabel!
    @IBOutlet weak var pointLbl: UILabel!
    @IBOutlet weak var totalMoneyLbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     "-----------URL--------"
     "http://star.test.wwwcity.net/app/transaction/get?orderno=1901_6ea3bd6848a1978a8825bf900420&sign=7be48a633c02448f601dad77ba36c2ce&cmdno=bUQ6KfP4Kx0SQT859uuw1548863101&cid=6&ts=1548863101"
     "-----------返回数据--------"
     {
     "code" : 0,
     "message" : "",
     "content" : {
     "transaction" : {
     "orderno" : "1901_6ea3bd6848a1978a8825bf900420",
     "servicetype" : "商圈支付",
     "atid" : "一卡通",
     "status" : "已支付",
     "totalprice" : "1.02",
     "orderItems" : [
     {
     "unit" : "个",
     "picurl" : "http:\/\/starlife3c.test.upcdn.net\/image\/201901\/1547110391729.jpg",
     "price" : "1.02",
     "oid" : 196,
     "title" : "测试商品",
     "totalprice" : "1.02",
     "pid" : 10096,
     "amount" : 1
     }
     ],
     "creationtime" : "2019-01-17 11:45:48",
     "memo" : "商圈支付",
     "money" : "0.00",
     "rejecttime" : "1970-01-01 08:00:00",
     "amount" : 1
     },
     "points" : {
     "money" : "1.02",
     "points" : "1.02"
     },
     "coupon" : [
     
     ]
     },
     "contentEncrypt" : ""
     }

     */
    
}
