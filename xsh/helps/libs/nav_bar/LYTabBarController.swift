//
//  LYTabBarController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/12.
//  Copyright © 2018年 wwzb. All rights reserved.
//


import UIKit

class LYTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabBarAppear = UITabBarItem.appearance()
        tabBarAppear.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:Normal_Color], for: UIControl.State.selected)
        
        self.setUpAllChildViewControllers()
        
        
        
        
        let lyTabBar = LYTabBar()
        lyTabBar.lyTabBarDelegate = self
        self.setValue(lyTabBar, forKey: "tabBar")
        
        tabBar.isTranslucent = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    func resetChildViewController(){
    //        for vc in self.childViewControllers{
    //            vc.removeFromParentViewController()
    //        }
    //
    //        self.setUpAllChildViewControllers()
    //
    //    }
    
    fileprivate func setUpAllChildViewControllers () {
        let titles = ["首页","购物","消息","我的"]
        let normalImgs = ["home_unselect","shop_unselect","message_unselect","personal_unselect"]
        let selectedImgs = ["home_select","shop_select","message_select","personal_select"]
        
            let firstVC = HomeViewController.spwan()
            setUpNavRootViewController(vc: firstVC, title: titles[0], imageName: normalImgs[0], selectedImageName: selectedImgs[0])
        
        let secVC = ShopViewController.spwan()
        setUpNavRootViewController(vc: secVC, title: titles[1], imageName: normalImgs[1], selectedImageName: selectedImgs[1])
        
        let thirVC = MessageViewController()
        setUpNavRootViewController(vc: thirVC, title: titles[2], imageName: normalImgs[2], selectedImageName: selectedImgs[2])

            let fourVC = PersonalViewController.spwan()
            setUpNavRootViewController(vc: fourVC, title: titles[3], imageName: normalImgs[3], selectedImageName: selectedImgs[3])
    }
    
    fileprivate func setUpNavRootViewController(vc: UIViewController, title: String, imageName: String, selectedImageName: String) {
        vc.title = title
        vc.tabBarItem.image = UIImage(named:imageName)
        vc.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        self.addChild(LYNavigationController.init(rootViewController: vc))
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension LYTabBarController{
    
    
    open override var shouldAutorotate: Bool{
        get{
            guard let value = self.selectedViewController?.shouldAutorotate else {
                return true
            }
            return value
        }
    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get{
            guard let value = self.selectedViewController?.supportedInterfaceOrientations else {
                return .portrait
            }
            return value
        }
    }
}



extension LYTabBarController : LYTabBarDelegate{
    func clickAction(tabbar: LYTabBar) {
        print("1")
        let scanVC = ScanActionViewController()
        scanVC.scanResultBlock = {(result) in
            
            scanVC.navigationController?.popViewController(animated: true)
            
            //http://star.wwwcity.net/B/商家id
            if result.hasPrefix("http://star.wwwcity.net/B"){
                self.scanCreateOrder(result)
            }else if result.hasPrefix("http://") || result.hasPrefix("https://"){
                let webVC = BaseWebViewController()
                webVC.titleStr = "扫描详情"
                webVC.urlStr = result
                self.navigationController?.pushViewController(webVC, animated: true)
            }else{
                LYProgressHUD.showInfo(result)
            }
            
        }
        self.selectedViewController?.children.last?.navigationController?.pushViewController(scanVC, animated: true)
    }
}


extension LYTabBarController{
    //二维码创建交易
    func scanCreateOrder(_ str : String) {
        let bid = str.replacingOccurrences(of: "http://star.wwwcity.net/B/", with: "")
        
        
        
        let rechargeAlert = UIAlertController.init(title: "支付", message: "请输入金额", preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
        }
        let recharge = UIAlertAction.init(title: "确定", style: .default) { (action) in
            guard let text = rechargeAlert.textFields?.first?.text else{
                LYProgressHUD.showError("请输入有效充值金额!")
                return
            }
            if text.floatValue <= 0{
                LYProgressHUD.showError("输入的金额无效!")
                return
            }
            
            
            //创建订单
            let params : [String : Any] = ["money" : text, "bid" : bid, "servicetype" : "qrcodepay"]
            NetTools.requestData(type: .post, urlString: ShopAddOrderApi, parameters: params, succeed: { (result) in
                let payVC = PayViewController()
                payVC.orderNo = result["orderno"].stringValue
                payVC.money = text
                payVC.titleStr = "商家支付"
                payVC.payResultBlock = {(type) in
                    if type == 1{
                        //成功
                        
                    }else if type == 2{
                        //取消
                        
                    }else if type == 3{
                        //失败
                        
                    }
                }
                self.selectedViewController?.children.last?.navigationController?.pushViewController(payVC, animated: true)
            }, failure: { (error) in
                LYProgressHUD.showError(error)
            })
            
        }
        rechargeAlert.addAction(recharge)
        rechargeAlert.addAction(cancel)
        rechargeAlert.addTextField { (tf) in
            tf.placeholder = "请输入支付金额"
        }
        self.present(rechargeAlert, animated: true, completion: nil)
    }
}
