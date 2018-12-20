//
//  BaseTableViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/13.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = BG_Color
        
    }

    
    func setUpRefre() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.RGB(r: 78, g: 221, b: 200)
        self.tableView.dg_addPullToRefreshWithActionHandler({
            
            self.tableView.dg_stopLoading()
            
        }, loadingView: loadingView)
        self.tableView.dg_setPullToRefreshFillColor(UIColor.RGB(r: 57, g: 67, b: 89))
        self.tableView.dg_setPullToRefreshBackgroundColor(self.tableView.backgroundColor!)
    }

    
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    
    
}
