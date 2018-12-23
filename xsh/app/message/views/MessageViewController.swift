//
//  MessageViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/12.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class MessageViewController: BaseTableViewController {

    
    fileprivate var messageList : Array<JSON> = []
    fileprivate var haveMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.register(UINib.init(nibName: "MessageCell", bundle: Bundle.main), forCellReuseIdentifier: "MessageCell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "全部已读", target: self, action: #selector(MessageViewController.rightItemAction))
        
        self.loadMessageData()
        self.pullToRefre {
            self.messageList.removeAll()
            self.loadMessageData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.messageList.count == 0{
            self.messageList.removeAll()
            self.loadMessageData()
        }
    }
    
    @objc func rightItemAction() {
        NetTools.requestData(type: .post, urlString: MessageAllReadApi, succeed: { (result) in
            LYProgressHUD.showSuccess("标记成功！")
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    //消息列表
    func loadMessageData() {
        var params : [String : Any] = [:]
        params["type"] = "0"
        params["lastid"] = "0"
        params["skip"] = self.messageList.count
        params["limit"] = "10"
        NetTools.requestData(type: .post, urlString: MessageListApi, parameters: params, succeed: { (result) in
            for json in result["list"].arrayValue{
                self.messageList.append(json)
            }
            if self.messageList.count < result["total"].intValue{
                self.haveMore = true
            }else{
                self.haveMore = false
            }
            self.tableView.reloadData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        if self.messageList.count > indexPath.row{
            let json = self.messageList[indexPath.row]
            cell.subJson = json
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.messageList.count > indexPath.row{
            let json = self.messageList[indexPath.row]
            let params : [String : Any] = ["id" : json["id"].stringValue]
            NetTools.requestData(type: .post, urlString: MessageDetailApi, parameters: params, succeed: { (result) in
                
            }) { (error) in
                LYProgressHUD.showError(error)
            }
        }
    }
    
}
