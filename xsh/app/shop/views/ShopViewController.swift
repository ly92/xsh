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

class ShopViewController: BaseViewController {
    class func spwan() -> ShopViewController{
        return self.loadFromStoryBoard(storyBoard: "Shop") as! ShopViewController
    }
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    fileprivate var bannerList : Array<JSON> = []
    fileprivate lazy var bannerView : LYAnimateBannerView = {
        let bannerView = LYAnimateBannerView.init(frame: CGRect(x: 0, y: 0, width: kScreenW, height: kScreenW * 190 / 375), delegate: self)
        bannerView.backgroundColor = UIColor.white
        bannerView.showPageControl = true
        return bannerView
    }()
    
    //功能栏
    fileprivate var functionList : Array<JSON> = []
    fileprivate let functionView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 92))
    
    //活动
    fileprivate var activityList : Array<JSON> = []
    fileprivate var ActivityView = UIScrollView(frame: CGRect(x: 0, y: 0, width: kScreenW, height: 95))
    
   

    fileprivate var recommendList : Array<JSON> = [] //底部推荐商品
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionView.register(UINib.init(nibName: "RecommendGoodsCell", bundle: Bundle.main), forCellWithReuseIdentifier: "RecommendGoodsCell")
        self.collectionView.register(HomeCollectionCell.self, forCellWithReuseIdentifier: "HomeCollectionCell")
        self.collectionView.register(RecommendReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RecommendReusableView")
        
        self.loadData()
        self.pullToRefre()
        
        //登录通知
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: KLoginSuccessNotiName), object: nil, queue: nil) { (noti) in
            self.loadData()
        }
        
        //视图在导航器中显示默认四边距离
        self.edgesForExtendedLayout = []
        if #available(iOS 11.0, *){
            self.collectionView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
    }
    
    
    
    
    
    func pullToRefre() {
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor.white
        self.collectionView.dg_addPullToRefreshWithActionHandler({
            self.loadData()
            self.collectionView.dg_stopLoading()
        }, loadingView: loadingView)
        self.collectionView.dg_setPullToRefreshFillColor(Normal_Color)
        self.collectionView.dg_setPullToRefreshBackgroundColor(self.collectionView.backgroundColor!)
    }
    
    //加载数据
    func loadData() {
        self.loadFunctionData()
        self.loadAdsData()
        self.loadActivity()
        self.loadRcommendGoods()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.edgesForExtendedLayout = UIRectEdge.top
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.clear, NSAttributedString.Key.font:UIFont.italicSystemFont(ofSize: 18.0)]
        
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
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.RGBS(s: 33), NSAttributedString.Key.font:UIFont.italicSystemFont(ofSize: 18.0)]
        
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
            self.functionList = result["list"].arrayValue
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
    
    
    
    //MARK:- 活动
    func loadActivity() {
        var params : [String : Any] = [:]
        params["location"] = "mainmiddle"
        params["skip"] = 0
        params["limit"] = 100
        NetTools.requestData(type: .post, urlString: AdListApi, parameters: params, succeed: { (result) in
            self.activityList = result["list"]["list"].arrayValue
            self.setUpActivityViews()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    //设置活动
    func setUpActivityViews() {
        for view in self.ActivityView.subviews{
            view.removeFromSuperview()
        }
        
        self.ActivityView.contentSize = CGSize.init(width: CGFloat(145 * self.activityList.count), height: self.ActivityView.h)
        for i in 0..<self.activityList.count{
            let json = self.activityList[i]
            let frame = CGRect.init(x: 145 * CGFloat(i) + 5, y: 0, width: 140, height: self.ActivityView.h)
            self.creareAvtivity(json["imageurl"].stringValue, i, frame)
        }
    }
    //创建活动页面
    func creareAvtivity(_ iconUrl : String, _ index : Int, _ frame : CGRect) {
        let imgV = UIImageView.init(frame: frame)
        imgV.contentMode = .scaleToFill
        imgV.setImageUrlStr(iconUrl)
        self.ActivityView.addSubview(imgV)
        
        let btn = UIButton(frame: frame)
        btn.tag = index
        btn.addTarget(self, action: #selector(ShopViewController.activityClickAction(_:)), for: .touchUpInside)
        self.ActivityView.addSubview(btn)
    }
    //活动点击效果
    @objc func activityClickAction(_ btn : UIButton) {
        if self.activityList.count > btn.tag{
            let json = self.activityList[btn.tag]
            let webVC = BaseWebViewController()
            webVC.titleStr = json["title"].stringValue
            let url = json["outerurl"].stringValue
            webVC.urlStr = url
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    
    
    //MARK:- 推荐商品
    func loadRcommendGoods() {
        NetTools.requestData(type: .post, urlString: RecommendGoodsApi, succeed: { (result) in
            self.recommendList.removeAll()
            for json in result["list"].arrayValue{
                self.recommendList.append(json)
            }
            self.collectionView.reloadData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
    }
    
}



//LYBannerViewDelegate
extension ShopViewController : LYAnimateBannerViewDelegate{
    func LY_AnimateBannerViewClick(banner:LYAnimateBannerView, index: NSInteger) {
        if self.bannerList.count > index{
            let json = self.bannerList[index]
            //            globalFunctionClickAction(json, self)
            let webVC = BaseWebViewController()
            webVC.titleStr = json["title"].stringValue
            let url = json["outerurl"].stringValue
            webVC.urlStr = url
            self.navigationController?.pushViewController(webVC, animated: true)
            
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


//MARK:- 推荐商品
extension ShopViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3 + recommendList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section > 2{
            if self.recommendList.count > section - 3{
                let recommendJson = self.recommendList[section-3]
                return recommendJson["productions"].arrayValue.count
            }
            return 0
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if indexPath.section == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
            cell.subView.addSubview(self.bannerView)
            return cell
        }else if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
            cell.subView.addSubview(self.functionView)
            return cell
        }else if indexPath.section == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
            cell.subView.addSubview(self.ActivityView)
            return cell
        }else if indexPath.section > 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendGoodsCell", for: indexPath) as! RecommendGoodsCell
            if self.recommendList.count > indexPath.section - 3{
                let productions = self.recommendList[indexPath.section-3]["productions"].arrayValue
                if productions.count > indexPath.row{
                    let json = productions[indexPath.row]
                    cell.subJson = json
                }
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.section > 2{
            if self.recommendList.count > indexPath.section - 3{
                let productions = self.recommendList[indexPath.section-3]["productions"].arrayValue
                if productions.count > indexPath.row{
                    let json = productions[indexPath.row]
                    let webVC = BaseWebViewController()
                    webVC.titleStr = "商品"
                    let ts = Date.phpTimestamp()
                    let cmdno = String.randomStr(len: 20) + ts
                    let sign = (LocalData.getCId() + ts + cmdno + LocalData.getPwd()).md5String()
                    let url = "http://star.test.wwwcity.net/shopping/index.html?bid=" + json["bid"].stringValue + "&cid=" + LocalData.getCId() + "&ts=" + ts + "&sign=" + sign + "&cmdno=" + cmdno + "&productionId=" + json["productionId"].stringValue
                    webVC.urlStr = url
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
            }
        }
    }
    
    
    

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section > 1{
            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "RecommendReusableView", for: indexPath) as! RecommendReusableView
            if indexPath.section == 2{
                reusableView.titleLbl.text = "最热门"
            }else if indexPath.section > 2{
                if indexPath.section > 2{
                    if self.recommendList.count > indexPath.section - 3{
                        let recommendJson = self.recommendList[indexPath.section-3]
                        reusableView.titleLbl.text = recommendJson["name"].stringValue
                    }
                }
            }
            return reusableView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section > 1{
            return CGSize.init(width: kScreenW, height: 50)
        }
        return CGSize.zero
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize.init(width: kScreenW, height: 190 / 375 * kScreenW)
        }else if indexPath.section == 1{
            return CGSize.init(width: kScreenW, height: 92)
        }else if indexPath.section == 2{
            return CGSize.init(width: kScreenW, height: 95)
        }else if indexPath.section > 2{
            let w = kScreenW / 2.0 - 1
            return CGSize.init(width: w, height: w * 1.2)
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}



class RecommendReusableView : UICollectionReusableView{
    fileprivate let lineView = UIView()
    let titleLbl = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: 50))
        view.backgroundColor = UIColor.white
        let subView = UIView.init(frame: CGRect.init(x: 12, y: 20, width: 3, height: 20))
        subView.backgroundColor = Normal_Color
        view.addSubview(subView)
        self.titleLbl.frame = CGRect.init(x: 20, y: 20, width: kScreenW - 20, height: 20)
        self.titleLbl.textColor = UIColor.RGB(r: 59, g: 71, b: 91)
        self.titleLbl.font = UIFont.systemFont(ofSize: 17.0)
        view.addSubview(self.titleLbl)
        self.addSubview(view)
    }
}






class HomeCollectionCell : UICollectionViewCell{
    fileprivate var subView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpUI()
    }
    //创建功能栏页面
    func setUpUI() {
        self.addSubview(self.subView)
        self.subView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(0)
        }
    }
}
