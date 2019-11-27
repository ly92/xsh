//
//  PersonalViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/12.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class PersonalViewController: BaseTableViewController {
    class func spwan() -> PersonalViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! PersonalViewController
    }
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var logoutBtn: UIButton!
    
    fileprivate var personalInfo = JSON()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.edgesForExtendedLayout = UIRectEdge.top
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear, NSAttributedString.Key.font:UIFont.italicSystemFont(ofSize: 18.0)]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadPersonalInfo()
        
        self.logoutBtn.layer.cornerRadius = 20
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.RGBS(s: 33), NSAttributedString.Key.font:UIFont.italicSystemFont(ofSize: 18.0)]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.icon.layer.cornerRadius = 30
        
        //登录通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: KLoginSuccessNotiName), object: nil, queue: nil) { (noti) in
            self.loadPersonalInfo()
        }
        //下拉刷新
        self.pullToRefre {
            self.loadPersonalInfo()
        }
        

    }
    //个人信息
    func loadPersonalInfo() {
        var params : [String : Any] = [:]
        params["id"] = LocalData.getCId()
        NetTools.requestData(type: .post, urlString: GetPersonalInfoApi, parameters: params, succeed: { (result) in
            self.personalInfo = result["user"]
            
            self.icon.setHeadImageUrlStr(result["user"]["iconurl"].stringValue)
            self.nameLbl.text = result["user"]["nickname"].stringValue
            let phone = result["user"]["mobile"].stringValue.trim
            if phone.isMobelPhone(){
                self.phoneLbl.text = phone.prefix(3) + "****" + phone.suffix(4)
            }else{
                self.phoneLbl.text = "***********"
            }
            
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    //退出
    @IBAction func logoutAction() {
        let loginVC = LoginViewController.spwan()
        
        if #available(iOS 13.0, *) {
            loginVC.modalPresentationStyle = .fullScreen
        } else {
            // Fallback on earlier versions
        }
        self.present(loginVC, animated: true) {
            LocalData.saveYesOrNotValue(value: "0", key: KIsLoginKey)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            //个人信息
            let personalVC = PersonalInfoViewController.spwan()
            personalVC.personalInfo = self.personalInfo
            self.navigationController?.pushViewController(personalVC, animated: true)
        }else if indexPath.row == 1{
            //我的优惠券
            let myCouponVC = MyCouponTableViewController()
            self.navigationController?.pushViewController(myCouponVC, animated: true)
        }else if indexPath.row == 2{
            //我的一卡通
            let myCardVC = MyCardViewController.spwan()
            self.navigationController?.pushViewController(myCardVC, animated: true)
        }else if indexPath.row == 3{
            //我的积分
            let pointsVC = MyPointsViewController.spwan()
            self.navigationController?.pushViewController(pointsVC, animated: true)
        }else if indexPath.row == 4{
            //我的交易
            let myOrderVC = MyOrderTableViewController()
            myOrderVC.orderType = 1
            self.navigationController?.pushViewController(myOrderVC, animated: true)
        }
//        else if indexPath.row == 4{
//            //我的二维码
//            let codeVC = MyQrcodeViewController()
//            self.navigationController?.pushViewController(codeVC, animated: true)
//        }
        else if indexPath.row == 5{
            //运动
            let motion = MotionViewController.spwan()
            self.navigationController?.pushViewController(motion, animated: true)
        }else if indexPath.row == 6{
            //修改密码
            let changePwd = ChangeCardPwdViewController.spwan()
            changePwd.isChangeLogin = true
            self.navigationController?.pushViewController(changePwd, animated: true)
        }
    }
    


}
