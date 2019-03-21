//
//  ComplaintViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/3/21.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class ComplaintViewController: BaseViewController {
    class func spwan() -> ComplaintViewController{
        return self.loadFromStoryBoard(storyBoard: "Home") as! ComplaintViewController
    }
    
    @IBOutlet weak var complantView: UIView!
    @IBOutlet weak var suggestView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    
    fileprivate var complantList : Array<JSON> = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "投诉建议"
        self.tableView.register(UINib.init(nibName: "ComplantCell", bundle: Bundle.main), forCellReuseIdentifier: "ComplantCell")
        
        //投诉
        self.complantView.addTapActionBlock {
            let complantVC = CreateComplantViewController.spwan()
            complantVC.type = 1
            self.navigationController?.pushViewController(complantVC, animated: true)
        }
        
        //建议
        self.suggestView.addTapActionBlock {
            let suggestVC = CreateComplantViewController.spwan()
            suggestVC.type = 2
            self.navigationController?.pushViewController(suggestVC, animated: true)
        }
        
        
    }
    

    //拨打电话
    @IBAction func phoneAction() {
        if UIApplication.shared.canOpenURL(URL.init(string: "tel://99988833")!){
            UIApplication.shared.open(URL.init(string: "tel://99988833")!, options: [:], completionHandler: nil)
        }
    }
    
    
    //历史单
    func loadComplantData() {
        NetTools.requestData(type: .post, urlString: ComplantSuggestListApi, succeed: { (result) in
            self.complantList = result["list"].arrayValue
            self.tableView.reloadData()
        }) { (error) in
            
        }
    }

}



extension ComplaintViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.complantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ComplantCell", for: indexPath) as! ComplantCell
        if self.complantList.count > indexPath.row{
            let json = self.complantList[indexPath.row]
            cell.subJson = json
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.complantList.count > indexPath.row{
            let json = self.complantList[indexPath.row]
            
        }
    }
    
    
}
