//
//  NoticeDetailViewController.swift
//  xsh
//
//  Created by ly on 2018/12/20.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class NoticeDetailViewController: BaseTableViewController {
    class func spwan() -> NoticeDetailViewController{
        return self.loadFromStoryBoard(storyBoard: "Shop") as! NoticeDetailViewController
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var readCountLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var contentImgV: UIImageView!
    
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var perpleLbl: UILabel!
    @IBOutlet weak var phoneBtn: UIButton!
    
    
    
    
    var noticeId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    //查询公告详情
    func loadNoticeDetail() {
        var params : [String : Any] = [:]
        params["id"] = self.noticeId
        NetTools.requestData(type: .post, urlString: NoticeDetailApi, parameters: params, succeed: { (result) in
            
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    


}
