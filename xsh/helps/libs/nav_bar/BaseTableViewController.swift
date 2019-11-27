//
//  BaseTableViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/13.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

typealias RefreshBlock = () -> Void

class BaseTableViewController: UITableViewController {

    
    fileprivate let emptyView = UIView()
    fileprivate let emptyBtn = UIButton()
    fileprivate var refreshBlock : (() -> Void)?
    
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
        
        
        self.emptyBtn.setTitleColor(Normal_Color, for: .normal)
        self.emptyBtn.setTitle("暂无数据，刷新试试！", for: .normal)
        self.emptyBtn.addTarget(self, action: #selector(BaseViewController.refreshAction), for: .touchUpInside)
        self.emptyView.addSubview(self.emptyBtn)
        self.emptyBtn.clipsToBounds = true
        self.emptyBtn.layer.cornerRadius = 5
        self.emptyBtn.setTitleColor(Normal_Color, for: .normal)
//        self.emptyBtn.backgroundColor = Normal_Color
        self.emptyView.backgroundColor = BG_Color
    }

    
    func showEmptyView(frame : CGRect, block : @escaping (() -> Void)) {
        LYProgressHUD.dismiss()
        if frame.origin.y == 88 || frame.origin.y == 64 {
            self.emptyView.frame = CGRect.init(x: frame.origin.x, y: 0, width: frame.size.width, height: frame.size.height)
        }else{
            self.emptyView.frame = frame
        }
        
        self.emptyBtn.frame = CGRect.init(x: frame.size.width / 2.0 - 100, y: frame.size.height / 2.0 - 25, width: 200, height: 50)
        self.emptyView.center = self.emptyView.center
        self.emptyView.isHidden = false
        if !self.view.subviews.contains(self.emptyView){
            self.view.addSubview(self.emptyView)
        }
        self.refreshBlock = block
    }
    
    func hideEmptyView() {
        LYProgressHUD.dismiss()
        self.emptyView.isHidden = true
    }
    
    @objc func refreshAction() {
        LYProgressHUD.showLoading()
        if self.refreshBlock != nil{
            self.refreshBlock!()
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
        if (self.tableView != nil){
            self.tableView.dg_removePullToRefresh()
        }
    }
    
    
    
}
