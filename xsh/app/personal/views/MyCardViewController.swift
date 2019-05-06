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
    @IBOutlet weak var rechargeBtn: UIButton!
    @IBOutlet weak var changePwdBtn: UIButton!
    @IBOutlet weak var cardNumView: UIView!
    @IBOutlet weak var showCodeView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的一卡通"
        
        
        
        self.rechargeBtn.layer.cornerRadius = 25
        self.changePwdBtn.layer.cornerRadius = 25
        
        self.loadCardDetail()
        
        self.showCodeView.addTapActionBlock {
            self.showCode()
        }
        
        self.cardNumView.addTapActionBlock {
            //绑定卡
//            let bindVC = BindCardTableViewController.spwan()
//            self.navigationController?.pushViewController(bindVC, animated: true)
        }
    }
    
    //一卡通历史
    @objc func rightItemAction() {
        let orderVC = MyOrderTableViewController()
        orderVC.orderType = 2
        self.navigationController?.pushViewController(orderVC, animated: true)
    }
    
    
    
    //检查是否开通了一卡通
//    func checkOpenCard() {
//
//        NetTools.requestData(type: .post, urlString: CardDetailApi, succeed: { (result) in
//
//        }) { (error) in
//            self.haveCard.isHidden = true
//            self.noCard.isHidden = false
//        }
//
//        NetTools.requestData(type: .post, urlString: CheckCardApi, succeed: { (result) in
//            if result["result"].intValue == 0{
//                self.haveCard.isHidden = true
//                self.noCard.isHidden = false
//            }else if result["result"].intValue == 1{
//                self.haveCard.isHidden = false
//                self.noCard.isHidden = true
//
//                self.loadCardDetail()
//            }
//        }) { (error) in
//            LYProgressHUD.showError(error)
//        }
//    }
    
    
    //一卡通详情
    func loadCardDetail() {
        NetTools.requestData(type: .post, urlString: CardDetailApi, succeed: { (result) in
            self.haveCard.isHidden = false
            self.noCard.isHidden = true
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "记录", target: self, action: #selector(MyCardViewController.rightItemAction))
            
            self.cardNumLbl.text = result["card"]["ano"].stringValue
            self.cardCountLbl.text = result["card"]["hardcount"].stringValue
//            self.moneyLbl.text = "¥" + result["card"]["money"].stringValue
            self.moneyLbl.text = result["card"]["money"].stringValue
        }) { (error) in
            self.haveCard.isHidden = true
            self.noCard.isHidden = false
        }
    }
    
    
    //展示二维码
    func showCode() {
        LYProgressHUD.showLoading()
        NetTools.requestData(type: .post, urlString: CardCodeApi, succeed: { (result) in
            LYProgressHUD.dismiss()
            DispatchQueue.main.async {
                show(result["qrcode"].stringValue)
            }
        }) { (error) in
            LYProgressHUD.showError(error)
        }
        func show(_ qrcode : String){
            let codeView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH))
            codeView.backgroundColor = UIColor.white
            let codeImgV = UIImageView.init(frame: CGRect.init(x: kScreenW / 2.0 - 125, y: kScreenH / 2.0 - 125, width: 250, height: 250))
            codeImgV.image = UIImageView.createQrcode(qrcode)
            codeView.addSubview(codeImgV)
            AppDelegate.sharedInstance.window?.addSubview(codeView)
            codeView.addTapActionBlock {
                codeView.removeFromSuperview()
            }
        }
    }
    
    
    
    @IBAction func btnAction(_ btn: UIButton) {
        if btn.tag == 11{
            //充值
            self.view.endEditing(true)
            
            let rechargeAlert = UIAlertController.init(title: "充值", message: "请输入充值金额", preferredStyle: .alert)
            let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
                
            }
            let recharge = UIAlertAction.init(title: "充值", style: .default) { (action) in
                guard let text = rechargeAlert.textFields?.first?.text else{
                    LYProgressHUD.showError("请输入有效充值金额!")
                    return
                }
//                if text.intValue == 0{
//                    LYProgressHUD.showError("输入的金额无效!")
//                    return
//                }
                //创建订单
                let params : [String : Any] = ["money" : text]
                NetTools.requestData(type: .post, urlString: CardRechargeApi, parameters: params, succeed: { (result) in
                    let payVC = PayViewController()
                    payVC.orderNo = result["orderno"].stringValue
                    payVC.money = text
                    payVC.titleStr = "一卡通充值"
                    payVC.payResultBlock = {(type) in
                        if type == 1{
                            //成功
                            self.loadCardDetail()
                        }else if type == 2{
                            //取消
                            
                        }else if type == 3{
                            //失败
                            
                        }
                    }
                    self.navigationController?.pushViewController(payVC, animated: true)
                }, failure: { (error) in
                    LYProgressHUD.showError(error)
                })
                
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
            openVC.openSucBlock = {() in
                self.loadCardDetail()
            }
            self.navigationController?.pushViewController(openVC, animated: true)
        }else if btn.tag == 44{
            //绑定卡
            let bindVC = BindCardTableViewController.spwan()
            self.navigationController?.pushViewController(bindVC, animated: true)
        }
    }
    

}


