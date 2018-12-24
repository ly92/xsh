//
//  MoreFunctionViewController.swift
//  xsh
//
//  Created by ly on 2018/12/21.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit


import UIKit
import SwiftyJSON

class MoreFunctionViewController: BaseViewController {
    
    //
    fileprivate var collectionView : UICollectionView!
    fileprivate var resultList : Array<JSON> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "更多"
        //配置collectionView
        self.setUpCollectionView()
        //        self.collectionView.backgroundColor = BG_Color
        
        self.collectionView.register(FunctionCell.self, forCellWithReuseIdentifier: "FunctionCell")
        
        self.loadData()
    }
    
    //配置collectionView
    func setUpCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        let w = (kScreenW - 20) / 4 - 10
        flowLayout.itemSize = CGSize.init(width: w, height: 90)
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 2
        flowLayout.headerReferenceSize = CGSize.init(width: kScreenW, height: 40)
        self.collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH-64), collectionViewLayout: flowLayout)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.view.addSubview(self.collectionView)
        self.collectionView.register(UINib.init(nibName: "HomeCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "MoreFunctionCollectionViewCell")
        self.collectionView.register(MoreFuncReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MoreFuncReusableView")
        self.collectionView.backgroundColor = UIColor.white
    }
    
    //加载数据
    func loadData() {
        NetTools.requestData(type: .post, urlString: FunctionMoreListApi, succeed: { (result) in
            for json in result["list"].arrayValue{
                self.resultList.append(json)
            }
            self.collectionView.reloadData()
        }) { (error) in
            LYProgressHUD.showError(error)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension MoreFunctionViewController : UICollectionViewDataSource, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.resultList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.resultList.count > section{
            let json = self.resultList[section]
            return json["modules"].arrayValue.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item : FunctionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FunctionCell", for: indexPath) as! FunctionCell
        if self.resultList.count > indexPath.section{
            let modules = self.resultList[indexPath.section]["modules"].arrayValue
            if modules.count > indexPath.row{
                let json = modules[indexPath.row]
                item.subJson = json
            }
        }
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if self.resultList.count > indexPath.section{
            let modules = self.resultList[indexPath.section]["modules"].arrayValue
            if modules.count > indexPath.row{
                let json = modules[indexPath.row]
                globalFunctionClickAction(json, self)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MoreFuncReusableView", for: indexPath) as! MoreFuncReusableView
        
        if self.resultList.count > indexPath.section{
            let json = self.resultList[indexPath.section]
            reusableView.titleLbl.text = json["name"].stringValue
            
        }
        return reusableView
    }
    
    
    
}

class MoreFuncReusableView : UICollectionReusableView{
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
        let lineView = UIView(frame:CGRect.init(x: 0, y: 0, width: kScreenW, height: 8))
        lineView.backgroundColor = BG_Color
        self.addSubview(lineView)
        
        self.titleLbl.frame = CGRect.init(x: 15, y: 15, width: kScreenW-30, height: 21)
        self.addSubview(titleLbl)
        self.titleLbl.textColor = Text_Color
        self.titleLbl.font = UIFont.systemFont(ofSize: 14.0)
        self.backgroundColor = UIColor.white
    }
    
}

class FunctionCell : UICollectionViewCell{
    fileprivate var imgV = UIImageView()
    fileprivate var titleLbl = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUpUI()
    }
    
    var subJson = JSON(){
        didSet{
            self.titleLbl.text = self.subJson["name"].stringValue
            self.imgV.setImageUrlStr(self.subJson["iconurl"].stringValue)
        }
    }
    
    
    //创建功能栏页面
    func setUpUI() {
        
        let view = UIView()
        self.addSubview(view)
        
        view.addSubview(self.imgV)
        
        self.titleLbl.textColor = UIColor.RGB(r: 133, g: 136, b: 141)
        self.titleLbl.font = UIFont.systemFont(ofSize: 12.0)
        view.addSubview(self.titleLbl)
        
        view.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalTo(0)
        }

        self.imgV.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(12)
            make.width.height.equalTo(50)
        }
        
        self.titleLbl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(imgV.snp.bottom).offset(4)
            make.height.equalTo(20)
        }
    }
    
    
    
}
