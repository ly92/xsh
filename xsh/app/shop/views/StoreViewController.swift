//
//  StoreViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/1/28.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit

class StoreViewController: BaseViewController {

    fileprivate var webView = UIWebView()
    
    public var urlStr : String = ""
    var bid = ""
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LYProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: kScreenH-self.navHeight)
        self.webView.delegate = self
        self.webView.scalesPageToFit = true
        self.view.addSubview(self.webView)
        
        //视图在导航器中显示默认四边距离
        if #available(iOS 11.0, *){
            self.webView.scrollView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.navigationItem.title = "商家"
        self.loadRequest()
        
        //返回按钮&关闭按钮
        let back = UIBarButtonItem.init(backTarget: self, action: #selector(StoreViewController.backClick))
        let close = UIBarButtonItem.init(image: #imageLiteral(resourceName: "delete_icon"), target: self, action: #selector(StoreViewController.closeClick))
        self.navigationItem.leftBarButtonItems = [back, close]
        //优惠券
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "免费领券", target: self, action: #selector(StoreViewController.rightItemaction))
        
        // Do any additional setup after loading the view.
    }
    
    func loadRequest() {
        if !urlStr.isEmpty{
            if !urlStr.hasPrefix("http://") && !urlStr.hasPrefix("https://"){
                urlStr = "http://" + urlStr
            }
            urlStr = urlStr.replacingOccurrences(of: " ", with: "")
            print("----------------------")
            print(urlStr)
            print("----------------------")
            let request = URLRequest.init(url: URL(string:urlStr)!)
            self.webView.loadRequest(request)
        }
    }
    
    
    @objc func backClick() {
        if self.webView.canGoBack{
            self.webView.goBack()
        }else{
           
                self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func closeClick() {
        self.webView.stopLoading()
        
            self.navigationController?.popViewController(animated: true)
    }
    
    @objc func rightItemaction(){
        let couponVC = CouponViewController()
        couponVC.isStore = true
        couponVC.bid = self.bid
        self.navigationController?.pushViewController(couponVC, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


extension StoreViewController : UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        LYProgressHUD.dismiss()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        LYProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        
        guard let requestUrl = request.url?.absoluteString.removingPercentEncoding else {
            return false
        }
        //去支付
        if requestUrl.contains("*payFromHtml5"){
            
            self.loadRequest()
            
            //http://39.108.218.19:8085/html/*payFromHtml5*1812_9c6bba0a4b09874a9a71a865f1e0*%E7%89%A9%E4%B8%9A%E8%B4%B9*0.01
            let arr = requestUrl.components(separatedBy: "*")
            if arr.count == 5{
                let orderNo = arr[2]
                let title = arr[3]
                let money = arr[4]
                let payVC = PayViewController()
                payVC.orderNo = orderNo
                payVC.money = money
                payVC.titleStr = title
                payVC.payResultBlock = {(type) in
                    if type == 1{
                        //成功
                    }else if type == 2{
                        //取消
                    }else if type == 3{
                        //失败
                    }
                }
                self.navigationController?.pushViewController(payVC, animated: true)
                
                return false
            }else{
                LYProgressHUD.showError("订单信息错误！")
            }
        }
        
        LYProgressHUD.showLoading()
        return true
    }
}
