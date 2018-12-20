//
//  MyCardViewController.swift
//  xsh
//
//  Created by ly on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyCardViewController: BaseViewController {
    class func spwan() -> MyCardViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! MyCardViewController
    }
    
    @IBOutlet weak var haveCard: UIView!
    @IBOutlet weak var noCard: UIView!
    
    @IBOutlet weak var haveCardImgV: UIImageView!
    @IBOutlet weak var noCardImgV: UIImageView!
    @IBOutlet weak var cardNumLbl: UILabel!
    @IBOutlet weak var cardCountLbl: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    @IBOutlet weak var creditLbl: UILabel!
    @IBOutlet weak var rechargeBtn: UIButton!
    @IBOutlet weak var changePwdBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的一卡通"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "", target: self, action: #selector(MyCardViewController.rightItemAction))
        
        self.checkOpenCard()
    }
    
    //一卡通历史
    @objc func rightItemAction() {
        
    }
    
    //检查是否开通了一卡通
    func checkOpenCard() {
        NetTools.requestData(type: .post, urlString: CheckCardApi, succeed: { (result) in
            if result["result"].intValue == 0{
                self.haveCard.isHidden = true
                self.noCard.isHidden = false
            }else if result["result"].intValue == 1{
                self.haveCard.isHidden = false
                self.noCard.isHidden = true
            }
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    
    
    @IBAction func btnAction(_ btn: UIButton) {
        if btn.tag == 11{
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
        }else if btn.tag == 22{
            //修改密码
            let changePwdVC = ChangeCardPwdViewController.spwan()
            self.navigationController?.pushViewController(changePwdVC, animated: true)
        }else if btn.tag == 33{
            //去开通
            let openVC = OpenCardViewController.spwan()
            self.navigationController?.pushViewController(openVC, animated: true)
        }else if btn.tag == 44{
            //绑定卡
            let bindVC = BindCardTableViewController.spwan()
            self.navigationController?.pushViewController(bindVC, animated: true)
        }
    }
    

}


