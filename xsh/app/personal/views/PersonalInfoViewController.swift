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
    
    fileprivate var areaId = ""
    fileprivate var communityId = ""
    fileprivate var areaStr = ""
    fileprivate var communityStr = ""
    
    fileprivate var gender = "1"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "个人信息"
        self.iconImgV.layer.cornerRadius = 22.5
        
        self.iconImgV.setHeadImageUrlStr(self.personalInfo["iconurl"].stringValue)
        self.nameLbl.text = self.personalInfo["nickname"].stringValue
        self.genderLbl.text = self.personalInfo["gender"].stringValue.intValue == 1 ? "男" : "女"
        self.addressLbl.text = self.personalInfo["area"].stringValue + " " + self.personalInfo["community"].stringValue
        
        let phone = self.personalInfo["mobile"].stringValue
        if phone.isMobelPhone(){
            self.phoneLbl.text = phone.prefix(3) + "****" + phone.suffix(4)
        }else{
            self.phoneLbl.text = "***********"
        }
        let idNum = self.personalInfo["identityid"].stringValue
        if idNum.isIdCard(){
            self.idLbl.text = idNum.prefix(4) + "**********" + idNum.suffix(4)
        }else{
            self.idLbl.text = "******************"
        }
        
        self.gender = self.personalInfo["gender"].stringValue
        self.areaId = self.personalInfo["areaid"].stringValue
        self.communityId = self.personalInfo["communityid"].stringValue
        
        self.tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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

   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            //头像
            TakeOnePhotoHelper.default.takePhoto(self) { (image) in
                LYProgressHUD.showLoading()
                NetTools.upLoadImage(urlString: ChangePersonIconApi, imgArray: [image], success: { (result) in
                    DispatchQueue.main.async {
                        self.iconImgV.image = image
                        LYProgressHUD.showSuccess("更新成功！")
                    }
                }, failture: { (error) in
                    LYProgressHUD.showError(error)
                })
            }
        }else if indexPath.row == 1{
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
            selectVC.areaId = self.personalInfo["areaid"].stringValue
            selectVC.areaStr = self.personalInfo["area"].stringValue
            selectVC.communityId = self.personalInfo["communityid"].stringValue
            selectVC.communityStr = self.personalInfo["community"].stringValue
            selectVC.selectBlok = {(areaId, areaStr, communityId, communityStr) in
                self.areaId = areaId
                self.communityId = communityId
                self.areaStr = areaStr
                self.communityStr = communityStr
                self.addressLbl.text = areaStr + " " + communityStr
                self.updatePersonalInfo()
            }
            self.navigationController?.pushViewController(selectVC, animated: true)
            
        }else if indexPath.row == 4{
            //绑定手机号
            let changePhoneVC = ChangePhoneViewController.spwan()
            self.navigationController?.pushViewController(changePhoneVC, animated: true)
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
            if self.addressLbl.resizeHeight() > 14{
                return self.addressLbl.resizeHeight() + 30
            }
            return 44
        }else{
            return 44
        }
    }
}
