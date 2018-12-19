//
//  LYUpScrollBannerView.swift
//  qixiaofu
//
//  Created by ly on 2017/10/24.
//  Copyright © 2017年 qixiaofu. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol LYUpScrollBannerViewDelegate {
    func LY_UpScrollBannerViewClick(index:NSInteger)
}

class LYUpScrollBannerView: UIView {

    var LY_UpScrollBannerViewClickBlock : ((Int) -> Void)?
    
    fileprivate var delegate : LYUpScrollBannerViewDelegate?
    fileprivate var collectionView : UICollectionView!
    var timer : Timer?
    fileprivate var isAutoScrolling = true
    
    fileprivate var bannerType = 0//0:公告 1:成交信息
    
    //公告
    var titleArray = Array<String>(){
        didSet{
            self.bannerType = 0
            self.collectionView.reloadData()
            if self.titleArray.count > 1{
                self.collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 2), at: .top, animated: false)
                self.addTimer()
            }
        }
    }
    
    //成交信息
    var transactionArray : JSON = []{
        didSet{
            self.bannerType = 1
            self.collectionView.reloadData()
            if self.transactionArray.arrayValue.count > 1{
                self.collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 2), at: .top, animated: false)
                self.addTimer()
            }
        }
    }
    
    init(frame:CGRect,delegate:LYUpScrollBannerViewDelegate) {
        super.init(frame: frame)
        self.frame = frame
        self.setUpCollectionView()
        collectionView.register(UINib.init(nibName: "BannerScrollTitleCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BannerScrollTitleCell")
        collectionView.register(UINib.init(nibName: "TransactionBannerCell", bundle: Bundle.main), forCellWithReuseIdentifier: "TransactionBannerCell")
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: self.w, height: self.h)
        self.collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.backgroundColor = UIColor.clear
        self.addSubview(self.collectionView)
    }
    
    //设置定时器
    func addTimer()  {
        self.removeTimer()
        self.timer = Timer(timeInterval: 3.0, target: self, selector: #selector(LYUpScrollBannerView.nextPage), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: .default)
        timer!.fire()
        self.isAutoScrolling = true
    }
    //移除定时器
    func removeTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func nextPage() {
        if !self.isAutoScrolling{
            return
        }
        
        // 1.马上显示回最中间那组的数据
        let currentIndexPathReset = self.resetIndexPath()
        // 2.计算出下一个需要展示的位置
        var nextItem = currentIndexPathReset.item + 1
        var nextSection = currentIndexPathReset.section
        if self.bannerType == 1{
            if nextItem == self.transactionArray.count {
                nextItem = 0
                nextSection += 1
            }
        }else{
            if nextItem == self.titleArray.count {
                nextItem = 0
                nextSection += 1
            }
        }
        let nextIndexPath = IndexPath.init(item: nextItem, section: nextSection)
        // 3.通过动画滚动到下一个位置
        self.collectionView.scrollToItem(at: nextIndexPath, at: .top, animated: true)
    }
    
    func resetIndexPath() -> IndexPath {
        //current indexpath
        guard let currentIndexPath = self.collectionView.indexPathsForVisibleItems.last else{
            return IndexPath.init(item: 0, section: 2)
        }
        //马上显示回最中间那组的数据
        let currentIndexPathReset = IndexPath.init(item: currentIndexPath.item, section: 2)
        self.collectionView.scrollToItem(at: currentIndexPathReset, at: .top, animated: false)
        return currentIndexPathReset
    }
    
    
    
}

extension LYUpScrollBannerView : UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.bannerType == 1{
            return self.transactionArray.arrayValue.count
        }else{
            return self.titleArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.bannerType == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TransactionBannerCell", for: indexPath) as! TransactionBannerCell
            if self.transactionArray.arrayValue.count > indexPath.row{
                let json = self.transactionArray.arrayValue[indexPath.row]
                cell.timeLbl.text =  Date.dateStringFromDate(format: Date.dateBiasFormatString(), timeStamps: json["user_sucess_time"].stringValue)
//                cell.nameLbl.text = json["ot_nik_name"].stringValue + "[" + json["entry_name"].stringValue + "]" + "挣了" + json["service_price"].stringValue + "元"
                cell.nameLbl.text = json["ot_nik_name"].stringValue + "完成项目挣了" + json["service_price"].stringValue + "元"
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerScrollTitleCell", for: indexPath) as! BannerScrollTitleCell
            if self.titleArray.count > indexPath.row{
                cell.titleLbl.text = self.titleArray[indexPath.row]
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.LY_UpScrollBannerViewClickBlock != nil{
            self.LY_UpScrollBannerViewClickBlock!(indexPath.row)
        }else{
            self.delegate?.LY_UpScrollBannerViewClick(index: indexPath.row)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isAutoScrolling = false
        self.removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.addTimer()
    }
}
