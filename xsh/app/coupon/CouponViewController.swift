//
//  CouponViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/12.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class CouponViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //登录通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: KLoginSuccessNotiName), object: nil, queue: nil) { (noti) in
            
        }
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
