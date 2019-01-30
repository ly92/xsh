//
//  BaseTableViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/13.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import DGElasticPullToRefresh

typealias RefreshBlock = () -> Void

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = BG_Color
        
        //视图在导航器中显示默认四边距离
        self.edgesForExtendedLayout = []
        if #available(iOS 11.0, *){
            self.tableView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }

    
    func pullToRefre(_ hander : @escaping RefreshBlock) {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        self.tableView.dg_addPullToRefreshWithActionHandler({
            hander()
            self.tableView.dg_stopLoading()
        }, loadingView: loadingView)
        self.tableView.dg_setPullToRefreshFillColor(Normal_Color)
        self.tableView.dg_setPullToRefreshBackgroundColor(self.tableView.backgroundColor!)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.default
    }
    
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    
    
}
