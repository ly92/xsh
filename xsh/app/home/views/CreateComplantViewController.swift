//
//  CreateComplantViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/3/21.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit

class CreateComplantViewController: BaseTableViewController {
    class func spwan() -> CreateComplantViewController{
        return self.loadFromStoryBoard(storyBoard: "Home") as! CreateComplantViewController
    }
    
    var type = 1 // 1:投诉 2:建议
    
    
    @IBOutlet weak var communityLbl: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var contentPlaceholderLbl: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var addressPlaceholderLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.type == 1{
            self.navigationItem.title = "投诉"
        }else if self.type == 2{
            self.navigationItem.title = "建议"
        }
        
    }
    
    
    @IBAction func submitAction() {
        
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
