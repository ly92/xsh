//
//  EvaluateOrderViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/3/26.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON


class EvaluateOrderViewController: BaseViewController {

    var orderno = ""
    var goodsList : Array<JSON> = []{
        didSet{
            for json in self.goodsList{
                self.evaluateResult[json["pid"].intValue] = 5
            }
        }
    }
    
    var evaluateSuccessBlock : (() -> Void)?
    
    fileprivate var tableView = UITableView()
    fileprivate var evaluateBtn = UIButton()
    
    fileprivate var evaluateResult : [Int : Int] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "评价"
        
        self.setUpUI()
        self.tableView.reloadData()
    }
    
    
    
    //布局
    func setUpUI() {
        
        self.view.addSubview(self.evaluateBtn)
        self.view.addSubview(self.tableView)
        
        self.evaluateBtn.addTarget(self, action: #selector(OrderDetailViewController.evaluateAction), for: .touchUpInside)
        self.evaluateBtn.setTitle("提交", for: .normal)
        self.evaluateBtn.backgroundColor = UIColor.white
        self.evaluateBtn.setTitleColor(Normal_Color, for: .normal)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = BG_Color
        self.tableView.separatorStyle = .none
        self.tableView.register(UINib.init(nibName: "EvaluateOrderGoodsCell", bundle: Bundle.main), forCellReuseIdentifier: "EvaluateOrderGoodsCell")
        
        self.evaluateBtn.snp.makeConstraints { (make) in
            make.bottom.leading.trailing.equalTo(0)
            make.height.equalTo(50)
        }
        self.tableView.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalTo(0)
            make.bottom.equalTo(self.evaluateBtn.snp.top)
        }
    }
    
    
    @objc func evaluateAction() {
        var arr : Array<[String:String]> = []
        var dict : [String:String] = [:]
        
        for key in self.evaluateResult.keys{
            dict["pid"] = String(key)
            dict["evaluate_score"] = String(self.evaluateResult[key]!)
            arr.append(dict)
        }
        var params : [String : Any] = [:]
        params["orderno"] = self.orderno
        params["evaluateJson"] = arr.jsonString()
        
        NetTools.requestData(type: .post, urlString: EvaluateOrderApi, parameters: params, succeed: { (result) in
            LYProgressHUD.showSuccess("评价成功！")
            if self.evaluateSuccessBlock != nil{
                self.evaluateSuccessBlock!()
            }
            self.navigationController?.popViewController(animated: true)
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    

}

extension EvaluateOrderViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goodsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EvaluateOrderGoodsCell", for: indexPath) as! EvaluateOrderGoodsCell
        if self.goodsList.count > indexPath.row{
            let json = self.goodsList[indexPath.row]
            cell.subJson = json
        }
        
        cell.startBlock = {(pid, code) in
            self.evaluateResult[pid] = code
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}


