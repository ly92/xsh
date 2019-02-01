//
//  MessageDetailViewController.swift
//  xsh
//
//  Created by ly on 2019/2/1.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit

class MessageDetailViewController: BaseViewController {
    class func spwan() -> MessageDetailViewController{
        return self.loadFromStoryBoard(storyBoard: "Message") as! MessageDetailViewController
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var contentH: NSLayoutConstraint!
    
    var messageId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "消息详情"
        
        self.loadMessageDetail()
    }
    

    func loadMessageDetail() {
        let params : [String : Any] = ["id" : self.messageId]
        NetTools.requestData(type: .post, urlString: MessageDetailApi, parameters: params, succeed: { (result) in
            self.titleLbl.text = result["message"]["title"].stringValue
            self.timeLbl.text = Date.dateStringFromDate(format: Date.dateChineseFormatString(), timeStamps: result["message"]["creationtime"].stringValue)
            self.contentLbl.text = result["message"]["content"].stringValue
            
            if self.contentLbl.frame.maxY < kScreenH{
                self.contentH.constant = kScreenH
            }else{
                self.contentH.constant = self.contentLbl.frame.maxY + self.navHeight
            }
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
}
