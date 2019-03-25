//
//  CreateComplantViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/3/21.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class CreateComplantViewController: BaseTableViewController {
    class func spwan() -> CreateComplantViewController{
        return self.loadFromStoryBoard(storyBoard: "Home") as! CreateComplantViewController
    }
    
    var isDetail = false
    var detailJson = JSON()
    var type = 1 // 1:投诉 2:建议
    
    
    @IBOutlet weak var communityLbl: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentPlaceholderLbl: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var addressPlaceholderLbl: UILabel!
    @IBOutlet weak var arrowImgV: UIImageView!
    @IBOutlet weak var subBtn: UIButton!
    
    
    fileprivate var selectedCommunity = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.type == 1{
            self.navigationItem.title = "投诉"
        }else if self.type == 2{
            self.navigationItem.title = "建议"
        }
        
        if self.isDetail{
            self.arrowImgV.isHidden = true
            self.subBtn.setTitle("评价", for: .normal)
            self.contentTextView.isEditable = false
            self.nameTF.isEnabled = false
            self.phoneTF.isEnabled = false
            self.addressPlaceholderLbl.isHidden = true
            self.contentPlaceholderLbl.isHidden = true
            self.setUpDetailUI()
        }
        
    }
    
    
    @IBAction func submitAction() {
        let content = self.contentTextView.text
        let image = self.imgV.image
        guard let user = self.nameTF.text else {
            LYProgressHUD.showInfo("请输入姓名")
            return
        }
        guard let mobile = self.phoneTF.text else {
            LYProgressHUD.showInfo("请输入联系方式")
            return
        }
        let address = self.addressTextView.text

        
        
        var params : [String : Any] = [:]
        params["communityid"] = self.selectedCommunity
        params["type"] = self.type
        params["content"] = content
        //        params["image"] = image
        params["username"] = user
        params["mobile"] = mobile
        params["address"] = address
        NetTools.requestData(type: .post, urlString: CreateComplantSuggestApi, parameters: params, succeed: { (result) in
            
        }) { (error) in
            
        }
        
        
    }
    
    //布局详情页面数据
    func setUpDetailUI() {
        self.communityLbl.text = self.detailJson["communityname"].stringValue
        self.contentTextView.text = self.detailJson["content"].stringValue
        self.imgV.setImageUrlStr(self.detailJson["image"].stringValue)
        self.nameTF.text = self.detailJson["username"].stringValue
        self.phoneTF.text = self.detailJson["mobile"].stringValue
        self.addressTextView.text = self.detailJson["address"].stringValue
    }
    
}

extension CreateComplantViewController : UITextViewDelegate, UITextFieldDelegate{
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


extension CreateComplantViewController{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            //选择小区
            let selectVC = SingleSelectTableViewController()
            selectVC.type = 3
            selectVC.selectBlock = {(json) in
                self.communityLbl.text = json["name"].stringValue
                self.selectedCommunity = json["communityid"].stringValue
            }
            self.navigationController?.pushViewController(selectVC, animated: true)
        }
    }
}

