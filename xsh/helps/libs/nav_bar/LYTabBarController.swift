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
        
        let secVC = ShopViewController()
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
        let scanVC = ScanActionViewController()
        scanVC.scanResultBlock = {(result) in
            //http://star.wwwcity.net/B/商家id
            if result.hasPrefix("http://star.wwwcity.net/B"){
                LYProgressHUD.showInfo("商家支付")
            }else if result.hasPrefix("http://") || result.hasPrefix("https://"){
                let webVC = BaseWebViewController()
                webVC.titleStr = "扫描详情"
                webVC.urlStr = result
                self.navigationController?.pushViewController(webVC, animated: true)
            }else{
                LYProgressHUD.showInfo(result)
            }
        }
        self.navigationController?.pushViewController(scanVC, animated: true)
    }
}
