//
//  MessageViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/12.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class MessageViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        self.pullToRefre {
            
        }
    }
    
    //消息列表
    func loadMessageData() {
        var params : [String : Any] = [:]
        params["type"] = "0"
        params["lastid"] = "0"
        params["skip"] = "0"
        params["limit"] = "10"
        NetTools.requestData(type: .post, urlString: MessageListApi, parameters: params, succeed: { (result) in
            
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }


    
    

}
