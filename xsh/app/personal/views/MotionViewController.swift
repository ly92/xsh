//
//  MotionViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/1/29.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON
import DGElasticPullToRefresh


class MotionViewController: BaseViewController {
    class func spwan() -> MotionViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! MotionViewController
    }
    
    
    @IBOutlet weak var titleTopDis: NSLayoutConstraint!
    @IBOutlet weak var numLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var stepsLogList : Array<JSON> = []
    fileprivate var haveMore = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.edgesForExtendedLayout = UIRectEdge.top
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear, NSAttributedString.Key.font:UIFont.italicSystemFont(ofSize: 18.0)]
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if self.navHeight > 64{
            self.titleTopDis.constant = 44
        }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.RGBS(s: 33), NSAttributedString.Key.font:UIFont.italicSystemFont(ofSize: 18.0)]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UINib.init(nibName: "MotionStepCell", bundle: Bundle.main), forCellReuseIdentifier: "MotionStepCell")
        
        self.loadStepsLog()
        self.pullToRefre()
        
        self.loadTodayStep()
    }
    
    
    func pullToRefre() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        self.tableView.dg_addPullToRefreshWithActionHandler({
            self.stepsLogList.removeAll()
            self.loadStepsLog()
            self.tableView.dg_stopLoading()
        }, loadingView: loadingView)
        self.tableView.dg_setPullToRefreshFillColor(Normal_Color)
        self.tableView.dg_setPullToRefreshBackgroundColor(self.tableView.backgroundColor!)
    }
    
    deinit {
        self.tableView.dg_removePullToRefresh()
    }
    
    
    //今日步数
    func loadTodayStep() {
        HealthHelper().requestStep(Date()) { (steps) in
            DispatchQueue.main.async {
                self.numLbl.text = "\(steps)"
                self.timeLbl.text = Date.dateStringFromDate(format: Date.timestampFormatString(), timeStamps: Date().phpTimestamp())
            }
        }
    }
    
    //打卡记录
    func loadStepsLog() {
        var params : [String : Any] = [:]
        params["skip"] = self.stepsLogList.count
        params["limit"] = 10
        NetTools.requestData(type: .post, urlString: StepsLogListApi, parameters: params, succeed: { (result) in
            if result["list"].arrayValue.count < 10{
                self.haveMore = false
            }else{
                self.haveMore = true
            }
            for json in result["list"].arrayValue{
                self.stepsLogList.append(json)
            }
            self.prepareData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    //预处理数据
    func prepareData() {
        let tempArray = self.stepsLogList
        for i in 0...tempArray.count - 1{
            var temp = tempArray[i]
            //status 0未打卡 1可补卡 2已打卡 3已过期
            let status = temp["status"].stringValue.intValue
            let date = Date.timestampToDate(Double(temp["date"].stringValue.intValue))
            if (status == 0 || status == 1) && temp["steps"].intValue == 0{
                HealthHelper().requestStep(date) { (steps) in
                    DispatchQueue.main.async {
                        temp["steps"] = JSON(steps)
                        self.stepsLogList.remove(at: i)
                        self.stepsLogList.insert(temp, at: i)
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    
    //返回按钮
    @IBAction func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}


extension MotionViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.stepsLogList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MotionStepCell", for: indexPath) as! MotionStepCell
        if self.stepsLogList.count > indexPath.row{
            let json = self.stepsLogList[indexPath.row]
            cell.subJson = json
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.stepsLogList.count - 1 && self.haveMore{
            self.loadStepsLog()
        }
    }
}
