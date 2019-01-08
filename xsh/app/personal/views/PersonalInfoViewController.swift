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
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var idLbl: UILabel!
    
    
    
    var personalInfo = JSON()
    
    fileprivate var gender = "1"
    fileprivate var areaId = ""
    fileprivate var communityId = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "个人信息"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.iconImgV.setImageUrlStr(self.personalInfo[""].stringValue)
        self.nameLbl.text = self.personalInfo["nickname"].stringValue
        self.genderLbl.text = self.personalInfo["gender"].stringValue.intValue == 1 ? "男" : "女"
        self.addressLbl.text = self.personalInfo["community"].stringValue + self.personalInfo["area"].stringValue
        self.phoneLbl.text = self.personalInfo["mobile"].stringValue
        self.idLbl.text = self.personalInfo["identityid"].stringValue
        self.gender = self.personalInfo["gender"].stringValue
        self.areaId = self.personalInfo["areaid"].stringValue
        self.communityId = self.personalInfo["communityid"].stringValue
        
        self.tableView.reloadData()
        
    }

    
    //修改个人信息
    func updatePersonalInfo() {
        var params : [String : Any] = [:]
        params["cid"] = self.personalInfo["cid"].stringValue
        params["nickname"] = self.nameLbl.text
        params["idcard"] = self.idLbl.text
        params["gender"] = self.gender
        params["areaid"] = self.areaId
        params["communityid"] = self.communityId
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
                self.nameLbl.text = nickName
                self.updatePersonalInfo()
            }
            self.navigationController?.pushViewController(changeVC, animated: true)
        }else if indexPath.row == 2{
             //性别
            LYPickerView.show(titles: ["男", "女"]) { (str, index) in
                self.genderLbl.text = str
                self.gender = index == 0 ? "1" : "2"
                self.updatePersonalInfo()
            }
        }else if indexPath.row == 3{
            //地址
            let selectVC = SelectCommunityViewController.spwan()
            selectVC.selectBlok = {(area, community) in
                self.areaId = area
                self.communityId = community
                self.updatePersonalInfo()
            }
            self.navigationController?.pushViewController(selectVC, animated: true)
            
        }else if indexPath.row == 5{
             //身份证号
            let changeVC = ChanegInfoViewController()
            changeVC.changeType = 2
            changeVC.editTextBlock = {(idStr) in
                self.idLbl.text = idStr
                self.updatePersonalInfo()
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
