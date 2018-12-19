//
//  LYAnimateBannerView.swift
//  qixiaofu
//
//  Created by ly on 2017/10/24.
//  Copyright © 2017年 qixiaofu. All rights reserved.
//


import UIKit


protocol LYAnimateBannerViewDelegate {
    func LY_AnimateBannerViewClick(banner:LYAnimateBannerView,index:NSInteger)
}

class LYAnimateBannerView: UIView {
    enum LY_BannerType {
        case ly_titleType
        case ly_imageType
        case ly_imageUrlType
    }
    
    var LY_AnimateBannerViewClickBlock : ((Int) -> Void)?
    var showPageControl = false
    
    
    fileprivate var delegate : LYAnimateBannerViewDelegate?
    fileprivate var collectionView : UICollectionView!
    var timer : Timer?
    fileprivate var type : LY_BannerType = .ly_titleType
    fileprivate var pageControl : UIPageControl?
    fileprivate var isAutoScrolling = false
    
    var titleArray = Array<String>(){
        didSet{
            self.type = .ly_titleType
            self.setUpCollectionView()
            if self.titleArray.count > 1{
                self.addTimer()
                self.collectionView.isScrollEnabled = true
            }else{
                self.collectionView.isScrollEnabled = false
            }
        }
    }
    var imageArray = Array<UIImage>(){
        didSet{
            self.type = .ly_imageType
            self.setUpCollectionView()
            if self.imageArray.count > 1{
                self.addTimer()
                self.collectionView.isScrollEnabled = true
            }else{
                self.collectionView.isScrollEnabled = false
            }
        }
    }
    var imageUrlArray = Array<String>(){
        didSet{
            self.type = .ly_imageUrlType
            self.setUpCollectionView()
            if self.imageUrlArray.count > 1{
                if self.type == .ly_titleType{
                    self.collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 2), at: .top, animated: false)
                }else{
                    self.collectionView.scrollToItem(at: IndexPath.init(row: 0, section: 2), at: .left, animated: false)
                }
                self.addTimer()
                self.collectionView.isScrollEnabled = true
            }else{
                self.collectionView.isScrollEnabled = false
            }
        }
    }

    init(frame:CGRect,delegate:LYAnimateBannerViewDelegate) {
        super.init(frame: frame)
        self.frame = frame
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = self.type == .ly_titleType ? .vertical : .horizontal
        layout.itemSize = CGSize.init(width: self.w, height: self.h)
        self.collectionView = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.isPagingEnabled = true
        collectionView.register(UINib.init(nibName: "BannerScrollTitleCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BannerScrollTitleCell")
        collectionView.register(UINib.init(nibName: "BannerScrollImageCell", bundle: Bundle.main), forCellWithReuseIdentifier: "BannerScrollImageCell")
        self.addSubview(self.collectionView)
        self.collectionView.reloadData()
        
        self.setUpPageControl()
    }
    
    //set pagecontrol
    func setUpPageControl() {
        //少于两个的时候不用滚动
        if self.collectionView.numberOfItems(inSection: 0) < 2{
            return
        }
        if self.pageControl != nil{
            self.pageControl = nil
            self.pageControl?.removeFromSuperview()
        }
        self.pageControl = UIPageControl()
        self.pageControl?.numberOfPages = self.collectionView.numberOfItems(inSection: 0)
        self.pageControl?.currentPageIndicatorTintColor = UIColor.darkGray
        self.pageControl?.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl?.frame = CGRect.init(x: 0, y: self.h - 30, width: self.w, height: 30)
        self.addSubview(self.pageControl!)
    }
    
    //设置定时器
    func addTimer()  {
        if self.timer != nil{
            self.removeTimer()
        }
       
        self.timer = Timer(timeInterval: 3.0, target: self, selector: #selector(LYAnimateBannerView.nextPage), userInfo: nil, repeats: true)
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
        
        if self.type == .ly_titleType{
            if nextItem == self.titleArray.count {
                nextItem = 0
                nextSection += 1
            }
        }else if self.type == .ly_imageUrlType{
            if nextItem == self.imageUrlArray.count {
                nextItem = 0
                nextSection += 1
            }
        }else{
            if nextItem == self.imageArray.count {
                nextItem = 0
                nextSection += 1
            }
        }
        
        let nextIndexPath = IndexPath.init(item: nextItem, section: nextSection)
        // 3.通过动画滚动到下一个位置
        if self.type == .ly_titleType{
            self.collectionView.scrollToItem(at: nextIndexPath, at: .top, animated: true)
        }else{
            self.collectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
        }
        
        self.pageControl?.currentPage = nextItem
    }
    
    func resetIndexPath() -> IndexPath {
        //current indexpath
        guard let currentIndexPath = self.collectionView.indexPathsForVisibleItems.last else{
            return IndexPath.init(item: 0, section: 2)
        }
        //马上显示回最中间那组的数据
        let currentIndexPathReset = IndexPath.init(item: currentIndexPath.item, section: 2)
        if self.type == .ly_titleType{
            self.collectionView.scrollToItem(at: currentIndexPathReset, at: .top, animated: false)
        }else{
            self.collectionView.scrollToItem(at: currentIndexPathReset, at: .left, animated: false)
        }
        return currentIndexPathReset
    }
    
    
    
}

extension LYAnimateBannerView : UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.type == .ly_titleType{
            return self.titleArray.count
        }else if self.type == .ly_imageUrlType{
            return self.imageUrlArray.count
        }else{
            return self.imageArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.type == .ly_titleType{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerScrollTitleCell", for: indexPath) as! BannerScrollTitleCell
            if self.titleArray.count > indexPath.row{
                cell.titleLbl.text = self.titleArray[indexPath.row]
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerScrollImageCell", for: indexPath) as! BannerScrollImageCell
            if self.type == .ly_imageUrlType{
                if self.imageUrlArray.count > indexPath.row{
                    cell.imgV.kf.setImage(with: URL(string:self.imageUrlArray[indexPath.row]))
                }
            }else{
                if self.imageArray.count > indexPath.row{
                    cell.imgV.image = self.imageArray[indexPath.row]
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.LY_AnimateBannerViewClickBlock != nil{
            self.LY_AnimateBannerViewClickBlock!(indexPath.row)
        }else{
            self.delegate?.LY_AnimateBannerViewClick(banner: self, index: indexPath.row)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.removeTimer()
        self.isAutoScrolling = false
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentIndexPathReset = self.resetIndexPath()
        self.pageControl?.currentPage = currentIndexPathReset.item
        self.addTimer()
    }
}
