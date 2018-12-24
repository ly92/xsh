//
//  ShopViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/12.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON
import DGElasticPullToRefresh

class ShopViewController: BaseTableViewController {
   
    
    
    fileprivate var bannerList : Array<JSON> = []
    fileprivate lazy var bannerView : LYAnimateBannerView = {
        let bannerView = LYAnimateBannerView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW * 190 / 375), delegate: self)
        bannerView.backgroundColor = UIColor.white
        bannerView.showPageControl = true
        return bannerView
    }()
    
    fileprivate var functionList : Array<JSON> = []
    fileprivate let functionView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 92))
    
    fileprivate var activityList : Array<JSON> = []
    fileprivate var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup collectionview
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize.init(width: 140, height: 125)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: 120), collectionViewLayout: layout)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        
        self.tableView.register(UINib.init(nibName: "GoodsCell", bundle: Bundle.main), forCellReuseIdentifier: "GoodsCell")
       self.collectionView.register(UINib.init(nibName: "ActivityCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ActivityCell")
        
        
        self.loadFunctionData()
        self.loadAdsData()
        self.loadActivity()
        
        self.pullToRefre {
            self.loadFunctionData()
            self.loadAdsData()
            self.loadActivity()
        }
        
        //登录通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: KLoginSuccessNotiName), object: nil, queue: nil) { (noti) in
            self.loadFunctionData()
            self.loadAdsData()
            self.loadActivity()
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.edgesForExtendedLayout = UIRectEdge.top
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.bannerView.timer?.invalidate()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        UIApplication.shared.statusBarStyle = .default
        self.edgesForExtendedLayout = []
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }
    
    //MARK:- banner
    func loadAdsData() {
        var params : [String : Any] = [:]
        params["location"] = "maintop"
        params["skip"] = 0
        params["limit"] = 100
        NetTools.requestData(type: .post, urlString: AdListApi, parameters: params, succeed: { (result) in
            //banner
            var urlArray : Array<String> = []
            self.bannerList.removeAll()
            for json in result["list"]["list"].arrayValue{
                self.bannerList.append(json)
                urlArray.append(json["imageurl"].stringValue)
            }
            
            self.bannerView.imageUrlArray = urlArray
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }

    
    //MARK:- 功能栏
    //功能栏数据
    func loadFunctionData() {
        var params : [String : Any] = [:]
        params["userid"] = LocalData.getCId()
        NetTools.requestData(type: .post, urlString: FunctionListApi, parameters: params, succeed: { (result) in
            self.functionList.removeAll()
            for json in result["list"].arrayValue{
                self.functionList.append(json)
            }
            self.setUpFunctionViews()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    //设置功能栏
    func setUpFunctionViews() {
        for view in self.functionView.subviews{
            view.removeFromSuperview()
        }
        
        let w = kScreenW / CGFloat(self.functionList.count)
        
        for i in 0..<self.functionList.count{
            let json = self.functionList[i]
            
            let frame = CGRect.init(x: w * CGFloat(i), y: 0, width: w, height: self.functionView.h)
            self.createfunction(json["name"].stringValue, json["iconurl"].stringValue, i, frame)
        }
        
    }
    //创建功能栏页面
    func createfunction(_ title : String, _ img : String, _ index : Int, _ frame : CGRect) {
        let view = UIView.init(frame: frame)
        self.functionView.addSubview(view)
        let imgV = UIImageView()
        imgV.setImageUrlStr(img)
        view.addSubview(imgV)
        
        let lbl = UILabel()
        lbl.text = title
        lbl.textColor = UIColor.RGB(r: 133, g: 136, b: 141)
        lbl.font = UIFont.systemFont(ofSize: 12.0)
        view.addSubview(lbl)
        
        let btn = UIButton()
        btn.tag = index
        btn.addTarget(self, action: #selector(ShopViewController.functionClickAction(_:)), for: .touchUpInside)
        view.addSubview(btn)
        
        
        imgV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(12)
            make.width.height.equalTo(50)
        }
        
        lbl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imgV.snp.bottom).offset(4)
            make.height.equalTo(20)
        }
        
        btn.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(0)
        }
        
    }
    //功能栏点击效果
    @objc func functionClickAction( _ btn : UIButton) {
        if self.functionList.count > btn.tag{
            let json = self.functionList[btn.tag]
            globalFunctionClickAction(json, self)
        }
    }
    
    
}



//LYBannerViewDelegate
extension ShopViewController : LYAnimateBannerViewDelegate{
    func LY_AnimateBannerViewClick(banner:LYAnimateBannerView, index: NSInteger) {
        if self.bannerList.count > index{
            let json = self.bannerList[index]
            globalFunctionClickAction(json, self)
//            //查询广告位广告详情
//            func loadAdsDetail() {
//                var params : [String : Any] = [:]
//                params["id"] = json["id"]
//                NetTools.requestData(type: .post, urlString: AdDetailApi, parameters: params, succeed: { (result) in
//
//                }) { (error) in
//                    LYProgressHUD.showError(error)
//                }
//            }
        }
    }
    
}

//MARK:- UITableView--商品列表
extension ShopViewController{
    
   override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3{
            return 10
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            var cell = tableView.dequeueReusableCell(withIdentifier: "shop-headerbannerview")
            if cell == nil{
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "shop-headerbannerview")
            }
            cell?.contentView.addSubview(self.bannerView)
            
            return cell!
        }else if indexPath.section == 1{
            var cell = tableView.dequeueReusableCell(withIdentifier: "shop-functionview")
            if cell == nil{
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "shop-functionview")
            }
            cell?.contentView.addSubview(self.functionView)
            
            return cell!
        }else if indexPath.section == 2{
            var cell = tableView.dequeueReusableCell(withIdentifier: "shop-activityview")
            if cell == nil{
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "shop-activityview")
            }
            cell?.contentView.addSubview(self.collectionView)
            return cell!
        }else if indexPath.section == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCell", for: indexPath) as! GoodsCell
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 190 / 375 * kScreenW
        }else if indexPath.section == 1{
            return 92
        }else if indexPath.section == 2{
            return 120
        }else if indexPath.section == 3{
           return 120
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}

//MARK:- 中部活动
extension ShopViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    func loadActivity() {
        var params : [String : Any] = [:]
        params["location"] = "mainmiddle"
        params["skip"] = 0
        params["limit"] = 100
        NetTools.requestData(type: .post, urlString: AdListApi, parameters: params, succeed: { (result) in
            self.activityList.removeAll()
            for json in result["list"]["list"].arrayValue{
                self.activityList.append(json)
            }
            self.collectionView.reloadData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.activityList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
        if self.activityList.count > indexPath.row{
            let json = self.activityList[indexPath.row]
            cell.subJson = json
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if self.activityList.count > indexPath.row{
            let json = self.activityList[indexPath.row]
            globalFunctionClickAction(json, self)
        }
    }
    
    
}
