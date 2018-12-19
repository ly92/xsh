//
//  MyCouponTableViewController.swift
//  xsh
//
//  Created by ly on 2018/12/19.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class MyCouponTableViewController: BaseTableViewController {
    class func spwan() -> MyCouponTableViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! MyCouponTableViewController
    }
    
    var isSelect = false
    
    fileprivate var couponList : Array<JSON> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isSelect{
            self.navigationItem.title = ""
        }else{
            self.navigationItem.title = ""
        }
        
        self.tableView.register(UINib.init(nibName: "CouponCell", bundle: Bundle.main), forCellReuseIdentifier: "CouponCell")
        
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponCell", for: indexPath) as! CouponCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
