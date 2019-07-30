//
//  MotionViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/1/29.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON


class MotionViewController: BaseViewController {
    class func spwan() -> MotionViewController{
        return self.loadFromStoryBoard(storyBoard: "Personal") as! MotionViewController
    }
    
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleTopDis: NSLayoutConstraint!
    @IBOutlet weak var numLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var descLbl: UILabel!
    
    fileprivate var stepsLogList : Array<JSON> = []
    fileprivate var haveMore = true
    fileprivate var isLoadding = false
    fileprivate var rule = JSON()
    
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
        
        self.loadTodayStep()
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
        self.transPointRule()
        
        self.pullToRefre()
        
        
        
        //颜色渐变
        let layer = CAGradientLayer()
        let color1 = UIColor.colorHex(hex: "6DDABD").cgColor
        let color2 = UIColor.colorHex(hex: "50BEA1").cgColor
        layer.colors = [color1, color2]
        layer.locations = [0.5, 1.0]
        layer.startPoint = CGPoint.init(x: 0, y: 0)
        layer.endPoint = CGPoint.init(x: 0, y: 1)
        layer.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: self.topView.h)
        self.topView.layer.addSublayer(layer)
        
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
    
    //积分兑换规则
    func transPointRule() {
        NetTools.requestData(type: .post, urlString: StepTransPointRuleApi, succeed: { (result) in
            self.rule = result
//            self.descLbl.text = result["remark"].stringValue
            self.descLbl.text = "每日签到有积分奖励，每周将会对累计打卡步数排名靠前者有额外积分奖励，积分可在积分商城中换购商品。"
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
    
    //今日步数
    func loadTodayStep() {
        HealthHelper().requestStep(Date()) { (step) in
            if step == -1{
                LYAlertView.show("未允许访问健康数据", "使用此功能请在设置中允许访问健康数据", "取消", "确定",{
                    let url = URL(string:UIApplication.openSettingsURLString)
                    if UIApplication.shared.canOpenURL(url!){
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    }
                })
            }else{
                DispatchQueue.main.async {
                    self.numLbl.text = "\(step)"
                }
            }
        }
        self.timeLbl.text = Date.dateStringFromDate(format: Date.timestampFormatString(), timeStamps: Date().phpTimestamp())
    }
    
    //打卡记录
    func loadStepsLog() {
        if self.isLoadding{
            return
        }
        self.isLoadding = true
        
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
            
            
            if self.stepsLogList.count > 0{
                self.prepareData()
                self.hideEmptyView()
            }else{
                self.showEmptyView(frame: self.tableView.frame) {
                    self.loadStepsLog()
                }
            }

            self.isLoadding = false
        }) { (error) in
            self.isLoadding = false
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
                HealthHelper().requestStep(date) { (step) in
                    if step != -1{
                        temp["steps"] = JSON(step)
                        self.stepsLogList.remove(at: i)
                        self.stepsLogList.insert(temp, at: i)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }

            }
        }
        self.tableView.reloadData()
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
            cell.rule = self.rule
            cell.subJson = json
            cell.refreshBlock = {() in
                self.stepsLogList.removeAll()
                self.loadStepsLog()
            }
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
