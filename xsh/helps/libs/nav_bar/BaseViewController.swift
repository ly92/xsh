//
//  BaseViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/13.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var navHeight : CGFloat{
        get{
            let statusFrame = UIApplication.shared.statusBarFrame
            let navFrame = self.navigationController?.navigationBar.frame
            let height = statusFrame.size.height + (navFrame?.size.height ?? 42)
            
            return height
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.default
    }
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
