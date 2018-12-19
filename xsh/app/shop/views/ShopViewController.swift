//
//  ShopViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/12.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
import SwiftyJSON

class ShopViewController: UIViewController {
    class func spwan() -> ShopViewController{
        return self.loadFromStoryBoard(storyBoard: "Shop") as! ShopViewController
    }
    
    
    @IBOutlet weak var hederView: UIView!
    @IBOutlet weak var functionView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentHeight: NSLayoutConstraint!
    
    fileprivate var bannerList : Array<JSON> = []
    
    fileprivate var functionList : Array<JSON> = []
    

    fileprivate lazy var bannerView : LYAnimateBannerView = {
        let bannerView = LYAnimateBannerView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW * 320 / 750), delegate: self)
        bannerView.backgroundColor = UIColor.white
        bannerView.showPageControl = true
        return bannerView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib.init(nibName: "GoodsCell", bundle: Bundle.main), forCellReuseIdentifier: "GoodsCell")
        self.collectionView.register(UINib.init(nibName: "ActivityCell", bundle: Bundle.main), forCellWithReuseIdentifier: "ActivityCell")
        
        self.hederView.addSubview(self.bannerView)
        
        
        self.loadFunctionData()
        
        self.scrollContentHeight.constant = kScreenH + 386
        
        self.loadAdsData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.bannerView.timer?.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    //MARK:--banner
    //查询广告位广告
    func loadAdsData() {
        var params : [String : Any] = [:]
        params["location"] = "maintop"
        params["skip"] = 0
        params["limit"] = 100
        NetTools.requestData(type: .post, urlString: AdListApi, parameters: params, succeed: { (result) in
            //banner
            var urlArray : Array<String> = []
            
            for json in result["list"].arrayValue{
                self.bannerList.append(json)
                urlArray.append(json["imageurl"].stringValue)
            }
            
            self.bannerView.imageUrlArray = urlArray
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }

    
    //MARK:--功能栏
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
            if json["actiontype"].intValue == 0{
                //跳转外部链接
                let webVC = BaseWebViewController()
                webVC.titleStr = json["name"].stringValue
                var url = json["actionurl"].stringValue
                url = url.replacingOccurrences(of: "$cid$", with: LocalData.getCId())
                webVC.urlStr = url
                self.navigationController?.pushViewController(webVC, animated: true)
            }else if json["actiontype"].intValue == 1{
                //跳转内部页面
                
            }else if json["actiontype"].intValue == 2{
                //第三方应用
                
            }else if json["actiontype"].intValue == 3{
                //保留
                
            }else if json["actiontype"].intValue == 4{
                //详情页
                
            }
        }
    }
    
   
    
    
}



//LYBannerViewDelegate
extension ShopViewController : LYAnimateBannerViewDelegate{
    func LY_AnimateBannerViewClick(banner:LYAnimateBannerView, index: NSInteger) {
        if self.bannerList.count > index{
            let json = self.bannerList[index]
            
            //查询广告位广告详情
            func loadAdsDetail() {
                var params : [String : Any] = [:]
                params["id"] = json["id"]
                NetTools.requestData(type: .post, urlString: AdDetailApi, parameters: params, succeed: { (result) in
                    
                }) { (error) in
                    LYProgressHUD.showError(error)
                }
            }
        }
    }
    
}

//UITableView--商品列表
extension ShopViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoodsCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
}

//活动列表
extension ShopViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
