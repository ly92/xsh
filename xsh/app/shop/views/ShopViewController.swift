//
//  ShopViewController.swift
//  xsh
//
//  Created by 李勇 on 2018/12/12.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    class func spwan() -> ShopViewController{
        return self.loadFromStoryBoard(storyBoard: "Shop") as! ShopViewController
    }
    
    
    @IBOutlet weak var hederView: UIView!
    @IBOutlet weak var functionView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    

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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.bannerView.timer?.invalidate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    //设置功能栏
    func setUpFunctionViews() {
        
        
    }
    
    func createBtn(_ title : String, _ img : String) -> UIButton {
        let btn = UIButton.init(type: .custom)
        
        btn.imageView?.contentMode = .scaleAspectFit
        btn.imageView?.setImageUrlStr(img)
        btn.setTitle(title, for: .normal)
        btn.setTitle(UIColor.RGBS(s: 33), for: .normal)
        btn.sizeToFit()
        
        let imageSize = btn.imageView?.frame.size ?? CGSize.init(width: 40, height: 40)
        let titleSize = btn.titleLabel?.frame.size ?? CGSize.init(width: 60, height: 20)
        
        
        btn.imageEdgeInsets = UIEdgeInsets.init(top: -titleSize.height - 10, left: 0, bottom: 0, right: -titleSize.width)
        btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -imageSize.width, bottom: -imageSize.height - 10, right: 0)
        
        btn.addTarget(self, action: #selector(ShopViewController.functionClickAction(_:)), for: .touchUpInside)
        
        return btn
    }
    
    //功能栏点击效果
    @objc func functionClickAction( _ btn : UIButton) {
        
    }

}



//LYBannerViewDelegate
extension ShopViewController : LYAnimateBannerViewDelegate{
    func LY_AnimateBannerViewClick(banner:LYAnimateBannerView, index: NSInteger) {
        NetTools.qxfClickCount("4")
        if self.banner_list.count > index{
            let subJson = self.banner_list[index]
            if subJson["url"].stringValue.trim.isEmpty{
                return
            }
            let webVC = BaseWebViewController.spwan()
            webVC.urlStr = subJson["banner_jump"].stringValue
            webVC.titleStr = subJson["banner_name"].stringValue
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
}

//UITableView--商品列表
extension ShopViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
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
