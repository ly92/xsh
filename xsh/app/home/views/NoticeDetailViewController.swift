//
//  NoticeDetailViewController.swift
//  xsh
//
//  Created by ly on 2018/12/20.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class NoticeDetailViewController: BaseTableViewController {
    class func spwan() -> NoticeDetailViewController{
        return self.loadFromStoryBoard(storyBoard: "Shop") as! NoticeDetailViewController
    }
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var readCountLbl: UILabel!
    @IBOutlet weak var descWeb: UIWebView!
    @IBOutlet weak var contentImgV: UIImageView!
    
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var peopleLbl: UILabel!
    @IBOutlet weak var phoneBtn: UIButton!
    
    
    
    
    var noticeId = ""
    
    fileprivate var noticeJson = JSON()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "公告详情"
        self.descWeb.scrollView.isScrollEnabled = false
        self.loadNoticeDetail()
    }

    
    //查询公告详情
    func loadNoticeDetail() {
        var params : [String : Any] = [:]
        params["id"] = self.noticeId
        NetTools.requestData(type: .post, urlString: NoticeDetailApi, parameters: params, succeed: { (result) in
            self.noticeJson = result["notice"]
            self.setUpUIData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    func setUpUIData() {
        self.titleLbl.text = self.noticeJson["title"].stringValue
        self.timeLbl.text = Date.dateStringFromDate(format: Date.dateChineseFormatString(), timeStamps: self.noticeJson["creationtime"].stringValue)
        self.readCountLbl.text = "阅读量：" + self.noticeJson["readcount"].stringValue
        let html = "<html> <body> " + self.noticeJson["content"].stringValue + "</body> </html>"
        self.descWeb.loadHTMLString(html, baseURL: URL(string:"www.baidu.com"))
        if !self.noticeJson["thumb"].stringValue.isEmpty{
            self.contentImgV.setImageUrlStr(self.noticeJson["thumb"].stringValue)
        }
        self.authorLbl.text = self.noticeJson["publisher"].stringValue + "  " + Date.dateStringFromDate(format: Date.dateFormatString(), timeStamps: self.noticeJson["creationtime"].stringValue)
        self.peopleLbl.text = self.noticeJson["contact"].stringValue
        self.phoneBtn.setTitle(self.noticeJson["tel"].stringValue, for: .normal)
        self.tableView.reloadData()
    }
    


}

extension NoticeDetailViewController : UIWebViewDelegate{
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return self.titleLbl.resizeHeight() + 60
        }else if indexPath.row == 1{
            return self.descWeb.scrollView.contentSize.height + 22
        }else if indexPath.row == 2{
            if self.noticeJson["thumb"].stringValue.isEmpty{
                return 0
            }else{
                guard let img = self.contentImgV.image else{
                    return 0
                }
                return img.size.height / img.size.width * self.contentImgV.w
            }
        }else if indexPath.row == 3{
            return 75
        }
        return 0
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        LYProgressHUD.showLoading()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.tableView.reloadData()
        LYProgressHUD.dismiss()
    }
}
