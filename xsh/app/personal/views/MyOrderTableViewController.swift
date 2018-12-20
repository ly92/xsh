//
//  MyOrderTableViewController.swift
//  xsh
//
//  Created by ly on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class MyOrderTableViewController: BaseTableViewController {

    var orderType = 1 // 1:我的订单，2:一卡通消费记录
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        
        self.tableView.register(UINib.init(nibName: "MyOrderCell", bundle: Bundle.main), forCellReuseIdentifier: "MyOrderCell")
    }
    
    
    //加载消费订单
    func loadShopOrder() {
        
    }
    
    
    //加载一卡通消费记录
    func loadCardOrder() {
        NetTools.requestData(type: .post, urlString: CardOrderListApi, succeed: { (result) in
            
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyOrderCell", for: indexPath) as! MyOrderCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
