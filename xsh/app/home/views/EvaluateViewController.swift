//
//  EvaluateViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/3/25.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit

class EvaluateViewController: BaseViewController {
    class func spwan() -> EvaluateViewController{
        return self.loadFromStoryBoard(storyBoard: "Home") as! EvaluateViewController
    }
    
    var id = ""
    var isRepair = false
    
    @IBOutlet weak var statisfactionBtn: UIButton!
    @IBOutlet weak var unstatisfactionBtn: UIButton!
    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "评价"
        
        self.view.addTapActionBlock {
            self.textView.resignFirstResponder()
        }
    }
    
    @IBAction func statisfactionBtnAction(_ btn: UIButton) {
        if btn.tag == 11{
            self.statisfactionBtn.isSelected = true
            self.unstatisfactionBtn.isSelected = false
        }else if btn.tag == 22{
            self.statisfactionBtn.isSelected = false
            self.unstatisfactionBtn.isSelected = true
        }else if btn.tag == 33{
            self.evaluateAction()
        }
    }
    
    //提交评价
    func evaluateAction() {
        var params : [String : Any] = [:]
        params["id"] = self.id
        guard let reason = self.textView.text else {
            return
        }
        if self.statisfactionBtn.isSelected{
            params["comments"] = "1"
        }else{
            params["comments"] = "2"
            if reason.isEmpty{
                LYProgressHUD.showError("请输入不满意的原因，以供我们完善服务！")
            }
        }
        
        var url = EvaluateComplantApi
        if self.isRepair{
            url = EvaluateRepairApi
        }
        
        NetTools.requestData(type: .post, urlString: url, parameters: params, succeed: { (result) in
            LYProgressHUD.showSuccess("提交成功！")
            
            
            if self.isRepair{
                //刷新维修列表
                NotificationCenter.default.post(name: NSNotification.Name.init("RefreshRepairListKey"), object: nil)
            }else{
                //刷新投诉建议列表
                NotificationCenter.default.post(name: NSNotification.Name.init("RefreshComplantListKey"), object: nil)
            }
            
            let vc = self.navigationController?.viewControllers[1]
            if vc == nil{
                self.navigationController?.popViewController(animated: true)
            }else{
                self.navigationController?.popToViewController(vc!, animated: true)
            }
        }) { (error) in
            LYProgressHUD.showError(error)
        }
        
    }
    
    
}
