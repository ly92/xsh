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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = ""
        
        self.tableView.register(UINib.init(nibName: "NoticeCell", bundle: Bundle.main), forCellReuseIdentifier: "NoticeCell")
        
    }

    
    
    //公告列表
    func loadNoticesData() {
        var params : [String : Any] = [:]
        params["skip"] = 0
        params["limit"] = "10"
        NetTools.requestData(type: .post, urlString: NoticeListApi, parameters: params, succeed: { (result) in
            
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    

    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.noticeList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell", for: indexPath) as! NoticeCell


        
        return cell
    }
   
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if self.noticeList.count > indexPath.row{
            let json = self.noticeList[indexPath.row]
            let detailVC = NoticeDetailViewController.spwan()
            detailVC.noticeId = json[""].stringValue
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }

}
