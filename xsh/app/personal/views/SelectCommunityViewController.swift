//
//  SelectCommunityViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/1/8.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class SelectCommunityViewController: BaseViewController {
    class func spwan() -> SelectCommunityViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! SelectCommunityViewController
    }
    
    var selectBlok : ((String, String) -> Void)?
    
    
    @IBOutlet weak var tableViewLeft: UITableView!
    @IBOutlet weak var tableViewRight: UITableView!
    
    fileprivate var areaList : Array<JSON> = []
    fileprivate var communityList : Array<JSON> = []
    fileprivate var areaId = "1"
    fileprivate var communityId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "选择地址"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "", target: self, action: #selector(SelectCommunityViewController.rightItemAction))
        
        self.loadAreaData()
    }
    
    
    @objc func rightItemAction() {
        if self.areaId.isEmpty || self.communityId.isEmpty{
            LYProgressHUD.showError("请选择小区")
            return
        }
        if self.selectBlok != nil{
            self.selectBlok!(self.areaId, self.communityId)
        }
    }
    
    
    func loadAreaData() {
        NetTools.requestData(type: .post, urlString: AreaListApi, succeed: { (result) in
            self.areaList = result["list"].arrayValue
            self.areaId = result["list"].arrayValue.first?["id"].stringValue ?? "0"
            self.tableViewLeft.reloadData()
            self.loadCommunityData()
            
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    func loadCommunityData() {
        let params : [String : Any] = ["areaid" : self.areaId]
        NetTools.requestData(type: .post, urlString: CommunityListApi, parameters: params, succeed: { (result) in
            self.communityList = result["list"].arrayValue
            self.tableViewRight.reloadData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }

    
    
}



extension SelectCommunityViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableViewLeft{
          return self.areaList.count
        }else{
            return self.communityList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "area-community-cell")
        if cell == nil{
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "area-community-cell")
        }
        cell?.textLabel?.textColor = UIColor.RGBS(s: 51)
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        
        if tableView == self.tableViewLeft{
            if self.areaList.count > indexPath.row{
                let json = self.areaList[indexPath.row]
                cell?.textLabel?.text = json["name"].stringValue
                if self.areaId == json["id"].stringValue{
                    cell?.textLabel?.textColor = Normal_Color
                }
            }
        }else{
            if self.communityList.count > indexPath.row{
                let json = self.communityList[indexPath.row]
                cell?.textLabel?.text = json["name"].stringValue
                if self.communityId == json["communityid"].stringValue{
                    cell?.textLabel?.textColor = Normal_Color
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableViewLeft{
            if self.areaList.count > indexPath.row{
                let json = self.areaList[indexPath.row]
                if self.areaId != json["id"].stringValue{
                    self.areaId = json["id"].stringValue
                    self.loadCommunityData()
                }
            }
        }else{
            if self.communityList.count > indexPath.row{
                let json = self.communityList[indexPath.row]
                if self.communityId != json["communityid"].stringValue{
                    self.communityId = json["communityid"].stringValue
                    self.tableViewRight.reloadData()
                }
            }
        }
    }
    
    
    
}

