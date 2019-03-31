//
//  CreateRepairViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/3/21.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class CreateRepairViewController: BaseTableViewController {
    class func spwan() -> CreateRepairViewController{
        return self.loadFromStoryBoard(storyBoard: "Home") as! CreateRepairViewController
    }
    
    var isDetail = false
    var detailJson = JSON()
    
    var type = 1 // 1:公共 2:个人
    
    
    @IBOutlet weak var communityLbl: UILabel!
    @IBOutlet weak var unitTF: UITextField!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentPlaceholderLbl: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var addressPlaceholderLbl: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var arrowImgV1: UIImageView!
    @IBOutlet weak var arrowImgV2: UIImageView!
    @IBOutlet weak var subBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    
    
    fileprivate var selectedCommunity = ""
    fileprivate var selectedCategory = ""
    fileprivate var offsetY : CGFloat = 0
    fileprivate var image : UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.type == 1{
            self.navigationItem.title = "公共维修"
        }else if self.type == 2{
            self.navigationItem.title = "个人维修"
        }
        
        if self.isDetail{
            self.arrowImgV1.isHidden = true
            self.arrowImgV2.isHidden = true
            
            self.subBtn.setTitle("评价", for: .normal)
            if self.detailJson["status"].intValue != 3{
                self.subBtn.isHidden = true
            }
            self.contentTextView.isEditable = false
            self.addressTextView.isEditable = false
            self.nameTF.isEnabled = false
            self.unitTF.isEnabled = false
            self.phoneTF.isEnabled = false
            self.addressPlaceholderLbl.isHidden = true
            self.contentPlaceholderLbl.isHidden = true
            self.setUpDetailUI()
        }else{
            self.imgV.addTapActionBlock {
                TakeOnePhotoHelper.default.takePhoto(self) { (image) in
                    self.imgV.image = image
                    self.image = image
                }
            }
            self.phoneTF.text = LocalData.getUserPhone()
            self.timeLbl.text = Date.dateStringFromDate(format: Date.datesFormatString(), timeStamps: Date().phpTimestamp())
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    
    //提交报修
    @IBAction func submitAction() {
        if self.isDetail{
            let evaluateVC = EvaluateViewController.spwan()
            evaluateVC.id = self.detailJson["id"].stringValue
            evaluateVC.isRepair = true
            self.navigationController?.pushViewController(evaluateVC, animated: true)
        }else{
            let content = self.contentTextView.text
            guard let user = self.nameTF.text else {
                LYProgressHUD.showInfo("请输入姓名")
                return
            }
            guard let mobile = self.phoneTF.text else {
                LYProgressHUD.showInfo("请输入联系方式")
                return
            }
            let address = self.addressTextView.text
            guard let unit = self.unitTF.text else {
                LYProgressHUD.showInfo("请输入单元号")
                return
            }
            
            
            var params : [String : String] = [:]
            params["communityid"] = self.selectedCommunity
            params["unit"] = unit
            params["maintype"] = String(self.type)
            params["subtype"] = self.selectedCategory
            params["content"] = content
            params["username"] = user
            params["mobile"] = mobile
            params["address"] = address
            LYProgressHUD.showLoading()
            if self.image == nil{
                NetTools.requestData(type: .post, urlString: CreateRepairApi, parameters: params, succeed: { (result) in
                    LYProgressHUD.showSuccess("提交成功，请耐心等候！")
                    //刷新维修列表
                    NotificationCenter.default.post(name: NSNotification.Name.init("RefreshRepairListKey"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }) { (error) in
                    LYProgressHUD.showError(error)
                }
            }else{
                NetTools.requestDataWithImage(type: .post, urlString: CreateRepairApi, imgArray: [self.image!], imageName: "image", parameters: params, succeed: { (result) in
                    LYProgressHUD.showSuccess("提交成功，请耐心等候！")
                    //刷新维修列表
                    NotificationCenter.default.post(name: NSNotification.Name.init("RefreshRepairListKey"), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }) { (error) in
                    LYProgressHUD.showError(error)
                }
            }
        }
    }
    
    
    //布局详情页面数据
    func setUpDetailUI() {
        self.communityLbl.text = self.detailJson["communityname"].stringValue
        self.typeLbl.text = self.detailJson["typename"].stringValue
        self.unitTF.text = self.detailJson["unit"].stringValue
        self.contentTextView.text = self.detailJson["content"].stringValue
        self.imgV.setImageUrlStr(self.detailJson["image"].stringValue)
        self.nameTF.text = self.detailJson["username"].stringValue
        self.phoneTF.text = self.detailJson["mobile"].stringValue
        self.addressTextView.text = self.detailJson["address"].stringValue
        self.timeLbl.text = Date.dateStringFromDate(format: Date.datesFormatString(), timeStamps: self.detailJson["creationtime"].stringValue)
    }
    
}


extension CreateRepairViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1{
            if self.type == 1{
                return 0
            }else{
                return 1
            }
        }else if section == 2{
            return 3
        }else if section == 3{
            if self.isDetail{
                if self.detailJson["image"].stringValue.isEmpty{
                    return 0
                }
            }
            return 1
        }else if section == 4{
            return 2
        }else if section == 5{
            if self.isDetail{
                return 0
            }
            return 1
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 || indexPath.section == 1 {
            return 78
        }else if indexPath.section == 2{
            if indexPath.row == 0{
                return 78
            }else if indexPath.row == 1{
                if self.isDetail{
                    return self.contentTextView.text.sizeFitTextView(width: kScreenW - 30, height: CGFloat(MAXFLOAT), fontSize: 14.0).height + 32
                }
                return 113
            }else if indexPath.row == 2{
                return 44
            }
        }else if indexPath.section == 3{
            return 128
        }else if indexPath.section == 4{
            if indexPath.row == 0{
                return 208
            }else if indexPath.row == 1{
                return 52
            }
        }else if indexPath.section == 5{
            return 360
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isDetail{
            return
        }
        
        //选择小区
        if indexPath.section == 0{
            let selectVC = SingleSelectTableViewController()
            selectVC.type = 3
            selectVC.selectBlock = {(json) in
                self.communityLbl.text = json["name"].stringValue
                self.selectedCommunity = json["communityid"].stringValue
            }
            self.navigationController?.pushViewController(selectVC, animated: true)
        }else if indexPath.section == 2{
            //报修类型
            if indexPath.row == 0{
                let selectVC = SingleSelectTableViewController()
                selectVC.type = self.type
                selectVC.selectBlock = {(json) in
                    self.typeLbl.text = json["name"].stringValue
                    self.selectedCategory = json["id"].stringValue
                }
                self.navigationController?.pushViewController(selectVC, animated: true)
            }
        }
    }
    
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.tableView{
            self.offsetY = scrollView.contentOffset.y
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView{
            if self.offsetY > scrollView.contentOffset.y{
                self.view.endEditing(true)
            }
        }
    }
    
}


extension CreateRepairViewController : UITextViewDelegate, UITextFieldDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == self.contentTextView{
            self.contentPlaceholderLbl.isHidden = true
        }else if textView == self.addressTextView{
            self.addressPlaceholderLbl.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.contentPlaceholderLbl.isHidden = !self.contentTextView.text.isEmpty
        self.addressPlaceholderLbl.isHidden = !self.addressTextView.text.isEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
