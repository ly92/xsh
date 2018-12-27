//
//  PersonalInfoViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/26.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class PersonalInfoViewController: BaseTableViewController {
    class func spwan() -> PersonalInfoViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! PersonalInfoViewController
    }
    
    @IBOutlet weak var iconImgV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    
    
    var personalInfo = JSON()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.iconImgV.setImageUrlStr(self.personalInfo[""].stringValue)
        self.nameLbl.text = self.personalInfo["nickname"].stringValue
        self.addressLbl.text = self.personalInfo["community"].stringValue + self.personalInfo["area"].stringValue
        self.phoneLbl.text = self.personalInfo["mobile"].stringValue
        self.idLbl.text = self.personalInfo["identityid"].stringValue
        self.tableView.reloadData()
        
    }

    
    //修改个人信息
    func updatePersonalInfo() {
        var params : [String : Any] = [:]
        params["cid"] = self.personalInfo["cid"].stringValue
        params["nickname"] = LocalData.getCId()
        params["idcard"] = LocalData.getCId()
        params["communityid"] = LocalData.getCId()
        NetTools.requestData(type: .post, urlString: ChangePersonalInfoApi, parameters: params, succeed: { (result) in
            
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }

    
    //修改手机号信息
    func updatePersonalPhone() {
        var params : [String : Any] = [:]
        params["cid"] = LocalData.getCId()
        params["mobile"] = LocalData.getCId()
        params["code"] = LocalData.getCId()
        params["passwd"] = LocalData.getCId()
        NetTools.requestData(type: .post, urlString: ChangePhoneApi, parameters: params, succeed: { (result) in
            
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
             //名字
            let changeVC = ChanegInfoViewController()
            changeVC.changeType = 1
            changeVC.editTextBlock = {(nickName) in
                var params : [String : Any] = [:]
                params["cid"] = self.personalInfo["cid"].stringValue
                params["nickname"] = LocalData.getCId()
                params["idcard"] = LocalData.getCId()
                params["communityid"] = LocalData.getCId()
                NetTools.requestData(type: .post, urlString: ChangePersonalInfoApi, parameters: params, succeed: { (result) in
                    
                }) { (error) in
                    LYProgressHUD.showError(error)
                }
            }
            self.navigationController?.pushViewController(changeVC, animated: true)
        }else if indexPath.row == 2{
             //性别
            LYPickerView.show(titles: ["男", "女"]) { (str, index) in
                var params : [String : Any] = [:]
                params["cid"] = self.personalInfo["cid"].stringValue
                params["nickname"] = LocalData.getCId()
                params["idcard"] = LocalData.getCId()
                params["communityid"] = LocalData.getCId()
                NetTools.requestData(type: .post, urlString: ChangePersonalInfoApi, parameters: params, succeed: { (result) in
                    
                }) { (error) in
                    LYProgressHUD.showError(error)
                }
            }
        }else if indexPath.row == 4{
             //身份证号
            let changeVC = ChanegInfoViewController()
            changeVC.changeType = 2
            changeVC.editTextBlock = {(idStr) in
                var params : [String : Any] = [:]
                params["cid"] = self.personalInfo["cid"].stringValue
                params["nickname"] = LocalData.getCId()
                params["idcard"] = LocalData.getCId()
                params["communityid"] = LocalData.getCId()
                NetTools.requestData(type: .post, urlString: ChangePersonalInfoApi, parameters: params, succeed: { (result) in
                    
                }) { (error) in
                    LYProgressHUD.showError(error)
                }
            }
            self.navigationController?.pushViewController(changeVC, animated: true)
        }
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 60
        }else if indexPath.row == 3{
            return self.addressLbl.resizeHeight() + 30
        }else{
            return 44
        }
    }
}
