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
    
    fileprivate var isSelecting = false
    fileprivate var selectedIds = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.register(UINib.init(nibName: "MessageCell", bundle: Bundle.main), forCellReuseIdentifier: "MessageCell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "选择", target: self, action: #selector(MessageViewController.rightItemAction))
        if LocalData.getUserPhone() == "18811016533" || LocalData.getUserPhone() == "18010069751"{
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "拍照", target: self, action: #selector(MessageViewController.leftItemAction))
        }
        self.pullToRefre {
            self.messageList.removeAll()
            self.loadMessageData()
        }
        
        
        //登录通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: KLoginSuccessNotiName), object: nil, queue: nil) { (noti) in
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
        
        self.tabBarItem.badgeValue = nil
        self.readAllAction()
    }
    
    @objc func rightItemAction() {
        if self.isSelecting{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "选择", target: self, action: #selector(MessageViewController.rightItemAction))
            self.deleteAction()
        }else{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "删除", target: self, action: #selector(MessageViewController.rightItemAction))
            
        }
        
        self.isSelecting = !self.isSelecting
        self.tableView.reloadData()
    }
    
    @objc func leftItemAction() {
        let takeVC = XCTakePhotoViewController.spwan()
        self.navigationController?.pushViewController(takeVC, animated: true)
    }
    
    
    //批量删除
    func deleteAction() {
        var params : [String : Any] = [:]
        params["ids"] = self.selectedIds.joined(separator: ",")
        NetTools.requestData(type: .post, urlString: MessageDeleteApi, parameters: params, succeed: { (result) in
            self.selectedIds.removeAll()
            self.messageList.removeAll()
            self.loadMessageData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    //全部标记为已读
    func readAllAction() {
        NetTools.requestData(type: .post, urlString: MessageAllReadApi, succeed: { (result) in
            self.tabBarItem.badgeValue = nil
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
            if result["list"].arrayValue.count < 10{
                self.haveMore = false
            }else{
                self.haveMore = true
            }
            if self.messageList.count > 0{
                self.hideEmptyView()
                self.tableView.reloadData()
            }else{
                self.showEmptyView(frame: self.tableView.frame) {
                    self.loadMessageData()
                }
            }
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
            if self.isSelecting{
                cell.selectImgV.isHidden = false
                if self.selectedIds.contains(json["id"].stringValue){
                    cell.selectImgV.image = UIImage.init(named: "gender_select")
                }else{
                    cell.selectImgV.image = UIImage.init(named: "gender_unselect")
                }
            }else{
                cell.selectImgV.isHidden = true
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.messageList.count > indexPath.row{
            let json = self.messageList[indexPath.row]
            if self.isSelecting{
                if self.selectedIds.contains(json["id"].stringValue){
                    if self.selectedIds.firstIndex(of: json["id"].stringValue) != nil{
                        self.selectedIds.remove(at: self.selectedIds.firstIndex(of: json["id"].stringValue)!)
                    }
                }else{
                    self.selectedIds.append(json["id"].stringValue)
                }
                self.tableView.reloadData()
            }else{
                let type = json["type"].stringValue.trim
                let extra = JSON.init(parseJSON: json["extra"].stringValue)
                if type == "trans"{
                    let detailVC = OrderDetailViewController()
                    detailVC.orderno = extra["orderno"].stringValue
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }else if type == "pay"{
                    let billdetailVC = BillPayDetailViewController.spwan()
                    billdetailVC.orderno = extra["orderno"].stringValue
                    billdetailVC.uuid = extra["uuid"].stringValue
                    self.navigationController?.pushViewController(billdetailVC, animated: true)
                }else if type == "coupon"{
                    //我的优惠券
                    let myCouponVC = MyCouponTableViewController()
                    self.navigationController?.pushViewController(myCouponVC, animated: true)
                }else{
                    let detailVC = MessageDetailViewController.spwan()
                    detailVC.messageId = json["id"].stringValue
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.messageList.count - 1 && self.haveMore{
            self.loadMessageData()
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            if self.messageList.count > indexPath.row{
                let json = self.messageList[indexPath.row]
                self.selectedIds.append(json["id"].stringValue)
                self.deleteAction()
            }
        }
    }
    
    
    
}
