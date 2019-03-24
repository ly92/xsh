//
//  CreateRepairViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/3/21.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit

class CreateRepairViewController: BaseTableViewController {
    class func spwan() -> CreateRepairViewController{
        return self.loadFromStoryBoard(storyBoard: "Home") as! CreateRepairViewController
    }
    
    var type = 1 // 1:公共 2:个人
    
    
    @IBOutlet weak var communityLbl: UILabel!
    @IBOutlet weak var unitTF: UITextField!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentPlaceholderLbl: UILabel!
    @IBOutlet weak var imagV: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var addressPlaceholderLbl: UILabel!
    @IBOutlet weak var addressTextView: UITextView!
    
    
    fileprivate var selectedCommunity = ""
    fileprivate var selectedCategory = ""
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.type == 1{
            self.navigationItem.title = "公共维修"
        }else if self.type == 2{
            self.navigationItem.title = "个人维修"
        }
        
        
        self.imagV.addTapActionBlock {
            TakeOnePhotoHelper.default.takePhoto(self) { (image) in
                self.imagV.image = image
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }

    
    //提交报修
    @IBAction func submitAction() {
        let content = self.contentTextView.text
        let image = self.imagV.image
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
        
        
        var params : [String : Any] = [:]
        params["communityid"] = self.selectedCommunity
        params["unit"] = unit
        params["maintype"] = self.type
        params["subtype"] = self.selectedCategory
        params["content"] = content
//        params["image"] = image
        params["username"] = user
        params["mobile"] = mobile
        params["address"] = address
        NetTools.requestData(type: .post, urlString: CreateRepairApi, parameters: params, succeed: { (result) in
            
        }) { (error) in
            
        }
        
        
    }
    
    

}


extension CreateRepairViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            if self.type == 1{
                return 0
            }else{
                return 1
            }
        }else{
            return 5
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
