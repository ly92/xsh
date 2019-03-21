//
//  ShopViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/12.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON
import DGElasticPullToRefresh

class ShopViewController: BaseViewController {
    class func spwan() -> ShopViewController{
        return self.loadFromStoryBoard(storyBoard: "Shop") as! ShopViewController
    }
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var storeList : Array<JSON> = []
    fileprivate var industryStrList : Array<String> = []
    fileprivate var industryList : Array<JSON> = []
    
    @IBOutlet weak var industryLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    fileprivate var industry = "0"
    fileprivate var disrance = "2000"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib.init(nibName: "StoreCell", bundle: Bundle.main), forCellReuseIdentifier: "StoreCell")
        
        self.loadFilterData()
        self.loadStoreData()
        self.pullToRefre()
        
        //视图在导航器中显示默认四边距离
        self.edgesForExtendedLayout = []
        if #available(iOS 11.0, *){
            self.tableView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.filterAction()
        
    }
    
    
    //筛选事件
    func filterAction() {
        self.industryLbl.addTapActionBlock {
            LYPickerView.show(titles: self.industryStrList) { (str, index) in
                self.industryLbl.text = str
                if self.industryList.count > index{
                    let json = self.industryList[index]
                    self.industry = json[""].stringValue
                    
                    self.storeList.removeAll()
                    self.loadStoreData()
                }
            }
        }
        
        self.distanceLbl.addTapActionBlock {
            LYPickerView.show(titles: ["500m", "1000m", "2000m", "5000m"]) { (str, index) in
                self.distanceLbl.text = str
                self.disrance = str.replacingOccurrences(of: "m", with: "")
                
                self.storeList.removeAll()
                self.loadStoreData()
            }
        }
    }
    
    
    //加载筛选条件
    func loadFilterData() {
        NetTools.requestData(type: .post, urlString: StoreIndustryApi, succeed: { (result) in
            self.industryList.removeAll()
            for json in result.arrayValue{
                self.industryStrList.append(json["name"].stringValue)
            }
            self.industryList = result.arrayValue
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    //商家列表
    func loadStoreData() {
        var params : [String : Any] = [:]
        params["longitude"] = BaiDuMap.default.getUserLocal().longitude
        params["latitude"] = BaiDuMap.default.getUserLocal().latitude
        params["industryid"] = self.industry
        params["distance"] = self.disrance
        params["limit"] = "10"
        params["skip"] = self.storeList.count
        NetTools.requestData(type: .post, urlString: StoreListApi, parameters: params, succeed: { (result) in
            for json in result["list"].arrayValue{
                self.storeList.append(json)
            }
            
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }
    
    
    func pullToRefre() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        self.tableView.dg_addPullToRefreshWithActionHandler({
            self.storeList.removeAll()
            self.loadStoreData()
            self.tableView.dg_stopLoading()
        }, loadingView: loadingView)
        self.tableView.dg_setPullToRefreshFillColor(Normal_Color)
        self.tableView.dg_setPullToRefreshBackgroundColor(self.tableView.backgroundColor!)
    }
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    
}


extension ShopViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoreCell", for: indexPath) as! StoreCell
        if self.storeList.count > indexPath.row{
            let json = self.storeList[indexPath.row]
            cell.subJson = json
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if self.storeList.count > indexPath.row{
            let json = self.storeList[indexPath.row]
            let webVC = StoreViewController()
            let ts = Date.phpTimestamp()
            let cmdno = String.randomStr(len: 20) + ts
            let sign = (LocalData.getCId() + ts + cmdno + LocalData.getPwd()).md5String()
            let url = usedServer.replacingOccurrences(of: "app/", with: "") + "shopping/index.html?bid=" + json["bid"].stringValue + "&cid=" + LocalData.getCId() + "&ts=" + ts + "&sign=" + sign + "&cmdno=" + cmdno + "&productionId=" + json["productionId"].stringValue
            webVC.urlStr = url
            webVC.bid = json["bid"].stringValue
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
}
