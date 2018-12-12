//
//  UIView+Category.swift
//  qixiaofu
//   _
//  | |      /\   /\
//  | |      \ \_/ /
//  | |       \_~_/
//  | |        / \
//  | |__/\    [ ]
//  |_|__,/    \_/
//
//  Created by 李勇 on 2017/6/5.
//  Copyright © 2017年 qixiaofu. All rights reserved.
//

import Foundation
import UIKit

typealias UIViewCategoryActionBlock = () -> Void
//var tapActionBlock : UIViewCategoryActionBlock?
struct RuntimeKey {
    static let viewTapKey = UnsafeRawPointer.init(bitPattern: "ViewTapKey".hashValue)
    /// ...其他Key声明
}

extension UIView{
    //添加点击事件
    func addTapAction(action:Selector, target:Any) {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target:target, action:action)
        self.addGestureRecognizer(tap)
    }
    
    func addTapActionBlock(action : UIViewCategoryActionBlock?) {
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target:self, action:#selector(UIView.testHandle))
        self.addGestureRecognizer(tap)
//        if (action != nil){
//            tapActionBlock = action
//        }
        objc_setAssociatedObject(self, RuntimeKey.viewTapKey!, action, .OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
    
    @objc func testHandle()  {
//        if ((tapActionBlock) != nil){
//            tapActionBlock!()
//        }
        let block = objc_getAssociatedObject(self, RuntimeKey.viewTapKey!) as! UIViewCategoryActionBlock
        block()
    }
    
    var x : CGFloat!{
        get {
            return self.frame.origin.x
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.x = newValue
            frame = tempFrame
        }
    }
    var y : CGFloat!{
        get {
            return self.frame.origin.y
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.origin.y = newValue
            frame = tempFrame
        }
    }
    //    var ly_center : CGPoint {
    //        get {
    //            return self.ly_center
    //        }
    //        set {
    //            var tempCenter = center
    //            tempCenter.x = newValue
    //            center = tempCenter
    //        }
    //    }
    var center_x : CGFloat {
        get {
            return self.center.x
        }
        set {
            var tempCenter = center
            tempCenter.x = newValue
            center = tempCenter
        }
    }
    var center_y : CGFloat {
        get {
            return self.center.y
        }
        set {
            var tempCenter = center
            tempCenter.y = newValue
            center = tempCenter
        }
    }
    var w : CGFloat!{
        get {
            return self.frame.size.width
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size.width = newValue
            frame = tempFrame
        }
    }
    var h : CGFloat!{
        get {
            return self.frame.size.height
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size.height = newValue
            frame = tempFrame
        }
    }
    var size : CGSize!{
        get {
            return self.frame.size
        }
        set {
            var tempFrame : CGRect = frame
            tempFrame.size = newValue
            frame = tempFrame
        }
    }
    
    func loadFromNib(nibName:String){
        let shadow = UIView.loadFromNibName(nibName: nibName)
        shadow.frame = self.bounds
        self.addSubview(shadow)
    }
    class func loadFromNib() -> UIView{
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let nibName = NSStringFromClass(self).replacingOccurrences(of: nameSpace + ".", with: "")
        return self.loadFromNibName(nibName: nibName)
    }
    
    class func loadFromNibName(nibName:String) -> UIView{
        return UINib.init(nibName: nibName, bundle: Bundle.main).instantiate(withOwner: nil, options: nil).last as! UIView
    }
    
}

//MARK: - 截屏
extension UIView{
    //frame: 需要截取的范围，若为nil，则为视图的大小
    func getScreenshotImage(_ frame:CGRect?) -> UIImage? {
        if let scrollView = self as? UIScrollView{
            return self.scrollViewScreenShot(scrollView, frame)
        }else if let webView = self as? UIWebView{
            let scrollView = webView.scrollView
            return self.scrollViewScreenShot(scrollView, frame)
        }else{
            let shotFrame = frame == nil ? self.bounds : frame!
            UIGraphicsBeginImageContextWithOptions(shotFrame.size, true, 0)
            guard let currentContext = UIGraphicsGetCurrentContext() else{ return nil }
            currentContext.translateBy(x: -shotFrame.origin.x, y: -shotFrame.origin.y)
            let path = UIBezierPath.init(rect: shotFrame)
            path.addClip()
            layer.render(in: currentContext)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return img
        }
    }
    func scrollViewScreenShot(_ scrollView : UIScrollView, _ frame : CGRect?) -> UIImage? {
        let shotFrame = frame == nil ? CGRect.init(origin: CGPoint.zero, size: scrollView.contentSize) : frame!
        UIGraphicsBeginImageContextWithOptions(shotFrame.size, false, 0)
        let savedContentOffset = scrollView.contentOffset
        let savedFrame = scrollView.frame
        scrollView.contentOffset = CGPoint.zero
        scrollView.frame = CGRect.init(origin: CGPoint.zero, size: scrollView.contentSize)
        
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        currentContext.translateBy(x: -shotFrame.origin.x, y: -shotFrame.origin.y)
        let path = UIBezierPath.init(rect: shotFrame)
        path.addClip()
        
        scrollView.layer.render(in: currentContext)
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        scrollView.contentOffset = savedContentOffset
        scrollView.frame = savedFrame
        
        return img
    }
    
    
}


extension UIImage{
    func reSizeImage(reSize:CGSize)->UIImage {
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect.init(x: 0, y: 0, width: reSize.width, height: reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
}
