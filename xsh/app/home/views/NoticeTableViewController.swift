//
//  NoticeTableViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class NoticeTableViewController: BaseTableViewController {

    fileprivate var noticeList : Array<JSON> = []
    fileprivate var haveMore = true
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "公告"
        
        self.tableView.register(UINib.init(nibName: "NoticeCell", bundle: Bundle.main), forCellReuseIdentifier: "NoticeCell")
        
        
        self.loadNoticesData()
        
        self.pullToRefre {
            self.noticeList.removeAll()
            self.loadNoticesData()
        }
    }
    
    

    
    
    //公告列表
    func loadNoticesData() {
        var params : [String : Any] = [:]
        params["skip"] = self.noticeList.count
        params["limit"] = "10"
        NetTools.requestData(type: .post, urlString: NoticeListApi, parameters: params, succeed: { (result) in
            for json in result["list"].arrayValue{
                self.noticeList.append(json)
            }
            if self.noticeList.count < result["list"]["total"].intValue{
                self.haveMore = true
            }else{
                self.haveMore = false
            }
            
            if self.noticeList.count > 0{
                self.hideEmptyView()
                self.tableView.reloadData()
            }else{
                self.showEmptyView(frame: self.tableView.frame) {
                    self.loadNoticesData()
                }
            }
            
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    

    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noticeList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as! NoticeCell

        if self.noticeList.count > indexPath.row{
            let json = self.noticeList[indexPath.row]
            cell.subJson = json
        }
        
        return cell
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if self.noticeList.count > indexPath.row{
            let json = self.noticeList[indexPath.row]
            
            if json["type"].intValue == 1{
                let webVC = BaseWebViewController()
                webVC.titleStr = json["title"].stringValue
                let url = json["outurl"].stringValue
                webVC.urlStr = url
                self.navigationController?.pushViewController(webVC, animated: true)
            }else{
                let detailVC = NoticeDetailViewController.spwan()
                detailVC.noticeId = json["id"].stringValue
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.noticeList.count - 1 && self.haveMore{
            self.loadNoticesData()
        }
    }

}

