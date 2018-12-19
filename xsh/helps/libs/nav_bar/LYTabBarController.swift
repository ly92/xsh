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
        tabBarAppear.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.orange], for: UIControl.State.selected)
        
        self.setUpAllChildViewControllers()
        
        tabBar.isTranslucent = false
        
        
        let lyTabBar = LYTabBar()
        lyTabBar.lyTabBarDelegate = self
        self.setValue(lyTabBar, forKey: "tabBar")
        
        
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
        let titles = ["购物","优惠券","消息","我的"]
        let normalImgs = ["shop_unselect","coupon_unselect","message_unselect","personal_unselect"]
        let selectedImgs = ["shop_select","coupon_select","message_select","personal_select"]
        
            let firstVC = ShopViewController.spwan()
            setUpNavRootViewController(vc: firstVC, title: titles[0], imageName: normalImgs[0], selectedImageName: selectedImgs[0])
        
        let secVC = CouponViewController()
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
        print("12345678954321`12345678987654322345678987654321234567")
    }
}
