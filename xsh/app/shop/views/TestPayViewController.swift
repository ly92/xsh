//
//  TestPayViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/8/4.
//  Copyright © 2019 wwzb. All rights reserved.
//

import UIKit

class TestPayViewController: BaseViewController {
    class func spwan() -> TestPayViewController{
        return self.loadFromStoryBoard(storyBoard: "Shop") as! TestPayViewController
    }
    
    @IBOutlet weak var moneyTf: UITextField!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "支付测试"

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnAction(_ btn: UIButton) {
        self.moneyTf.resignFirstResponder()
        if btn.tag == 11{
            //微信
            self.btn1.isSelected = true
            self.btn2.isSelected = false
            
        }else if btn.tag == 22{
            //支付宝
            self.btn1.isSelected = false
            self.btn2.isSelected = true
            
        }else if btn.tag == 99{
            //提交
        }
    }
    
}
