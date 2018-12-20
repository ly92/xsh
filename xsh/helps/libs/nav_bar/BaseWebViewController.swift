//
//  BaseWebViewController.swift
//  qixiaofu
//
//  Created by 李勇 on 2017/6/12.
//  Copyright © 2017年 qixiaofu. All rights reserved.
//

import UIKit

class BaseWebViewController: BaseViewController {

   fileprivate var webView = UIWebView()

    var isFromAdVC = false
    
    public var urlStr : String = ""
    public var titleStr: String = ""
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        LYProgressHUD.dismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.frame = self.view.bounds
        self.webView.delegate = self
        self.webView.scalesPageToFit = true
        self.view.addSubview(self.webView)
        
        
        if self.isFromAdVC{
            titleStr = "广告详情"
        }
        self.navigationItem.title = titleStr

        LYProgressHUD.showLoading()
        if !urlStr.isEmpty{
            if !urlStr.hasPrefix("http://") && !urlStr.hasPrefix("https://"){
                urlStr = "http://" + urlStr
            }
            urlStr = urlStr.replacingOccurrences(of: " ", with: "")
            
            let request = URLRequest.init(url: URL(string:urlStr)!)
            self.webView.loadRequest(request)
        }
        
        //返回按钮
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(backTarget: self, action: #selector(BaseWebViewController.backClick))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "delete_icon"), target: self, action: #selector(BaseWebViewController.closeClick))
        
        // Do any additional setup after loading the view.
    }
    
    
    @objc func backClick() {
        if self.webView.canGoBack{
            self.webView.goBack()
        }else{
            if self.isFromAdVC{

            }else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    @objc func closeClick() {
        self.webView.stopLoading()
        if self.isFromAdVC{

        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension BaseWebViewController : UIWebViewDelegate{
    func webViewDidStartLoad(_ webView: UIWebView) {

    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        LYProgressHUD.dismiss()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        LYProgressHUD.dismiss()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        LYProgressHUD.showLoading()
        return true
    }
    
}
