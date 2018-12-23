//
//  NoticeCell.swift
//  xsh
//
//  Created by 李勇 on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class NoticeCell: UITableViewCell {
    @IBOutlet weak var timeLb: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descWeb: UIWebView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var imgVW: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.subView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var subJson = JSON(){
        didSet{
            self.timeLb.text = Date.dateStringFromDate(format: Date.dateChineseFormatString(), timeStamps: self.subJson["creationtime"].stringValue)
            self.titleLbl.text = self.subJson["title"].stringValue
            self.setHtmlStr(self.subJson["content"].stringValue)
            if self.subJson["thumb"].stringValue.isEmpty{
                self.imgVW.constant = 0
            }else{
                self.imgVW.constant = 75
                self.imgV.setImageUrlStr(self.subJson["thumb"].stringValue)
            }
            
            
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
    
    
    func setHtmlStr(_ str : String) {
//        var body = str.replacingOccurrences(of: "&lt;", with: "<")
//        body = body.replacingOccurrences(of: "&gt;", with: ">")
//
//        let pattern1 = "<span style=\"[a-zA-Z]{1,10}-[a-zA-Z]{1,10}:\\d{0,10}.\\d{0,10}px;\">"
//        do{
//            let regex = try NSRegularExpression(pattern: pattern1, options: NSRegularExpression.Options(rawValue:0))
//            let res = regex.matches(in: body, options: NSRegularExpression.MatchingOptions(rawValue:0), range: NSMakeRange(0, body.count))
//            if res.count > 0 {
//                for checkRes in res{
//                    let start = body.index(body.startIndex, offsetBy: checkRes.range.location)
//                    let end = body.index(body.startIndex, offsetBy: (checkRes.range.length + checkRes.range.location))
//                    body.removeSubrange(Range(uncheckedBounds: (start, end)))
//                }
//            }
//            body = body.replacingOccurrences(of: "</span>", with: "")
//        }catch{
//        }
        
        let html = "<html> <body> " + str + "</body> </html>"
        self.descWeb.loadHTMLString(html, baseURL: URL(string:"www.baidu.com"))
    }
    
}
