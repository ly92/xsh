//
//  MyPointsViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/4/7.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyPointsViewController: BaseViewController {
    class func spwan() -> MyPointsViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! MyPointsViewController
    }
    
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leftLine: UIView!
    @IBOutlet weak var rightLine: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var monthBtn: UIButton!
    
    fileprivate var pointsListArray : Array<JSON> = []
    fileprivate var monthType = 1// 1:三月内 2:半年内 3:一年内
    fileprivate var type = 0 // 1: 支出  其他：收入
    fileprivate var rule = ""//积分规则url
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "我的积分"
        self.tableView.register(UINib.init(nibName: "MyPointsCell", bundle: Bundle.main), forCellReuseIdentifier: "MyPointsCell")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "规则", target: self, action: #selector(MyPointsViewController.rightItemAction))
        
        self.getPoints()
        self.getPointList()
        
        self.pullToRefre()
        
    }
    
    func pullToRefre() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        self.tableView.dg_addPullToRefreshWithActionHandler({
            self.pointsListArray.removeAll()
            self.getPointList()
            self.tableView.dg_stopLoading()
        }, loadingView: loadingView)
        self.tableView.dg_setPullToRefreshFillColor(Normal_Color)
        self.tableView.dg_setPullToRefreshBackgroundColor(self.tableView.backgroundColor!)
    }
    
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    
    @objc func rightItemAction() {
        let webVC = BaseWebViewController()
        webVC.titleStr = "积分规则"
        webVC.urlStr = self.rule
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    
    @IBAction func btnAction(_ btn: UIButton) {
        if btn.tag == 11{
            //收入
            self.leftLine.isHidden = false
            self.rightLine.isHidden = true
            self.type = 0
        }else if btn.tag == 22{
            //支出
            self.leftLine.isHidden = true
            self.rightLine.isHidden = false
            self.type = 1
        }else if btn.tag == 33{
            //选择
            self.filterView.isHidden = false
        }else if btn.tag == 44{
            //三月内
            self.monthBtn.setTitle(" 三月内", for: .normal)
            self.monthType = 1
            self.filterView.isHidden = true
        }else if btn.tag == 55{
            //半年内
            self.monthBtn.setTitle(" 半年内", for: .normal)
            self.monthType = 2
            self.filterView.isHidden = true
        }else if btn.tag == 66{
            //一年内
            self.monthBtn.setTitle(" 一年内", for: .normal)
            self.monthType = 3
            self.filterView.isHidden = true
        }else if btn.tag == 77{
            //取消选择
            self.filterView.isHidden = true
        }
        if btn.tag != 77 && btn.tag != 33{
            self.pointsListArray.removeAll()
            self.getPointList()
        }
    }
    
    //积分数量
    func getPoints() {
        NetTools.requestData(type: .post, urlString: GetPointsApi, succeed: { (result) in
            self.pointsLbl.text = result["points"].stringValue
            self.rule = result["rules"].stringValue
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    //积分流水
    func getPointList() {
        var params : [String : Any] = [:]
        params["type"] = self.type
        if self.monthType == 2{
            //半年内
            params["month"] = 6
        }else if self.monthType == 3{
            //一年内
            params["month"] = 12
        }else{
            //三月内
            params["month"] = 3
        }
        NetTools.requestData(type: .post, urlString: PointsListApi, parameters: params, succeed: { (result) in
            for json in result["list"].arrayValue{
                self.pointsListArray.append(json)
            }
            self.tableView.reloadData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    

}


extension MyPointsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pointsListArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPointsCell", for: indexPath) as! MyPointsCell
        if self.pointsListArray.count > indexPath.row{
            let json = self.pointsListArray[indexPath.row]
            cell.subJson = json
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 67
//        if self.pointsListArray.count > indexPath.row{
//            let json = self.pointsListArray[indexPath.row]
//            let size = json[""].stringValue.sizeFit(width: kScreenW - 16, height: CGFloat(MAXFLOAT), fontSize: 14.0)
//            if size.height > 22{
//                return 47 + size.height
//            }else{
//                return 67
//            }
//        }
        return 0
    }
}
