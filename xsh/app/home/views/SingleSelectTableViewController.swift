//
//  SingleSelectTableViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/3/21.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class SingleSelectTableViewController: BaseTableViewController {
    
    
    var type = 1 // 1:公共报修分类 2:个人报修分类 3:小区分类
    var selectBlock : ((JSON) -> Void)?
    
    fileprivate var communityList = Array<JSON>()
    fileprivate var repairCategoryList = Array<JSON>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.type == 1 || self.type == 2{
            self.loadRapairData()
        }else if self.type == 3{
            self.loadCommunityData()
        }
        
    }

    
    func loadCommunityData() {
        NetTools.requestData(type: .post, urlString: HouseListApi, succeed: { (result) in
            self.communityList = result["communitylist"].arrayValue
            if self.communityList.count > 0{
                self.hideEmptyView()
                self.tableView.reloadData()
            }else{
                self.showEmptyView(frame: self.tableView.frame) {
                    self.loadCommunityData()
                }
            }
        }) { (error) in
            LYProgressHUD.showError(error)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func loadRapairData() {
        let params : [String : Any] = ["maintype" : self.type]
        NetTools.requestData(type: .post, urlString: RepairCategoryApi, parameters: params, succeed: { (result) in
            self.repairCategoryList = result.arrayValue
            if self.repairCategoryList.count > 0{
                self.hideEmptyView()
                self.tableView.reloadData()
            }else{
                self.showEmptyView(frame: self.tableView.frame) {
                    self.loadRapairData()
                }
            }
        }) { (error) in
            LYProgressHUD.showError(error)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.type == 1 || self.type == 2{
            return self.repairCategoryList.count
        }else if self.type == 3{
            return self.communityList.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if self.type == 1 || self.type == 2{
            if self.repairCategoryList.count > indexPath.row{
                let json = self.repairCategoryList[indexPath.row]
                cell.textLabel?.text = json["name"].stringValue
            }else{
                cell.textLabel?.text = ""
            }
        }else if self.type == 3{
            if self.communityList.count > indexPath.row{
                let json = self.communityList[indexPath.row]
                cell.textLabel?.text = json["name"].stringValue
            }else{
                cell.textLabel?.text = ""
            }
        }
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var json = JSON()
        
        if self.type == 1 || self.type == 2{
            if self.repairCategoryList.count > indexPath.row{
                json = self.repairCategoryList[indexPath.row]
            }
        }else if self.type == 3{
            if self.communityList.count > indexPath.row{
                json = self.communityList[indexPath.row]
            }
        }
        
        if self.selectBlock != nil{
            self.selectBlock!(json)
        }
        self.navigationController?.popViewController(animated: true)
    }

}
