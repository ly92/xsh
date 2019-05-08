//
//  RepairViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/3/21.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON


class RepairViewController: BaseViewController {
    class func spwan() -> RepairViewController{
        return self.loadFromStoryBoard(storyBoard: "Home") as! RepairViewController
    }
    
    @IBOutlet weak var pubView: UIView!
    @IBOutlet weak var personView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var repairList : Array<JSON> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "报修"
        self.tableView.register(UINib.init(nibName: "ComplantCell", bundle: Bundle.main), forCellReuseIdentifier: "ComplantCell")
        
        //历史单
        self.loadRepairData()
        self.pullToRefre {
            self.loadRepairData()
        }
        
        //公共维修
        self.pubView.addTapActionBlock {
            let repairVC = CreateRepairViewController.spwan()
            repairVC.type = 1
            self.navigationController?.pushViewController(repairVC, animated: true)
        }
        
        //个人维修
        self.personView.addTapActionBlock {
            let repairVC = CreateRepairViewController.spwan()
            repairVC.type = 2
            self.navigationController?.pushViewController(repairVC, animated: true)
        }
        
        //刷新列表通知
        NotificationCenter.default.addObserver(self, selector: #selector(RepairViewController.loadRepairData), name: NSNotification.Name.init("RefreshRepairListKey"), object: nil)
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
    
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    //拨打电话
    @IBAction func phoneAction() {
        if UIApplication.shared.canOpenURL(URL.init(string: "tel://01069330744")!){
            UIApplication.shared.open(URL.init(string: "tel://01069330744")!, options: [:], completionHandler: nil)
        }
    }
    
    //维修列表
    @objc func loadRepairData() {
        NetTools.requestData(type: .post, urlString: RepairListApi, succeed: { (result) in
            self.repairList = result["list"].arrayValue
            self.tableView.reloadData()
//            if self.repairList.count > 0{
//                self.hideEmptyView()
//                self.tableView.reloadData()
//            }else{
//                self.showEmptyView(frame: self.tableView.frame) {
//                    self.loadRepairData()
//                }
//            }
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    

}


extension RepairViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repairList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComplantCell", for: indexPath) as! ComplantCell
        if self.repairList.count > indexPath.row{
            let json = self.repairList[indexPath.row]
            cell.subJson = json
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.repairList.count > indexPath.row{
            let json = self.repairList[indexPath.row]
            let detailVC = CreateRepairViewController.spwan()
            detailVC.detailJson = json
            detailVC.isDetail = true
            detailVC.type = json["maintype"].intValue
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
}

