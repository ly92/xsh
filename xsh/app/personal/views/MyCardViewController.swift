//
//  MyCardViewController.swift
//  xsh
//
//  Created by ly on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class MyCardViewController: BaseViewController {
    class func spwan() -> MyCardViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! MyCardViewController
    }
    
    @IBOutlet weak var haveCard: UIView!
    @IBOutlet weak var noCard: UIView!
    
    @IBOutlet weak var haveCardImgV: UIImageView!
    @IBOutlet weak var noCardImgV: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的一卡通"
        
    }
    
    @IBAction func btnAction(_ btn: UIButton) {
        if btn.tag == 1{
            //充值
            let rechargeAlert = UIAlertController.init(title: "充值", message: "请输入充值金额", preferredStyle: .alert)
            let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
                
            }
            let recharge = UIAlertAction.init(title: "充值", style: .default) { (action) in
                let text = rechargeAlert.textFields?.first?.text
                
            }
            rechargeAlert.addAction(recharge)
            rechargeAlert.addAction(cancel)
            rechargeAlert.addTextField { (tf) in
                tf.placeholder = "请输入整数"
            }
            self.present(rechargeAlert, animated: true, completion: nil)
        }else if btn.tag == 2{
            //修改密码
            
        }else if btn.tag == 2{
            //绑定卡
            
        }
    }
    

}


