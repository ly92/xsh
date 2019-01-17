//
//  CouponDetailViewController.swift
//  xsh
//
//  Created by ly on 2019/1/17.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class CouponDetailViewController: BaseViewController {
    class func spwan() -> CouponDetailViewController{
        return self.loadFromStoryBoard(storyBoard: "Home") as! CouponDetailViewController
    }
    
    
    @IBOutlet weak var numLbl: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    @IBOutlet weak var limitLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var storeList : Array<JSON> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = ""
        self.tableView.register(UINib.init(nibName: "CouponStoreCell", bundle: Bundle.main), forCellReuseIdentifier: "CouponStoreCell")
    }
    



}


extension CouponDetailViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.storeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CouponStoreCell", for: indexPath)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
}
