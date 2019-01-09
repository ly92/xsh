//
//  CouponViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/12.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class CouponViewController: BaseTableViewController {

    fileprivate var couponList : Array<JSON> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib.init(nibName: "CouponGetCell", bundle: Bundle.main), forCellReuseIdentifier: "CouponGetCell")
        
        
        
        //登录通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: KLoginSuccessNotiName), object: nil, queue: nil) { (noti) in
            
        }
    }
    
    
    func loadCouponData() {
        
    }

}


extension CouponViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponGetCell", for: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105
    }
}
