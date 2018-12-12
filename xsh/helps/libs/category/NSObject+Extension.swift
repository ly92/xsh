//
//  NSObject+Extension.swift
//  qixiaofu
//
//  Created by ly on 2017/6/20.
//  Copyright © 2017年 qixiaofu. All rights reserved.
//


import Foundation
import UIKit

// MARK: - 弹框
extension NSObject {
    /// 只有是控制器和继承UIView的控件才会弹框
    /**
     * - 弹框提示
     * - @param info 要提醒的内容
     */
    func showInfo(info: String) {
        if self.isKind(of: UIViewController.self) || self.isKind(of: UIView.self) {
            let alertVc = UIAlertController(title: info, message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: nil)
            alertVc.addAction(cancelAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertVc, animated: true, completion: nil)
        }
    }
    
    static func showInfo(info: String) {
        if self.isKind(of: UIViewController.self) || self.isKind(of: UIView.self) {
            let alertVc = UIAlertController(title: info, message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "好的", style: .cancel, handler: nil)
            alertVc.addAction(cancelAction)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertVc, animated: true, completion: nil)
        }
    }
}

// MARK: - RunTime
extension NSObject {
    /**
     获取所有的方法和属性
     - parameter cls: 当前类
     */
    func mg_GetMethodAndPropertiesFromClass(cls: AnyClass) {
        debugPrint("方法========================================================")
        var methodNum: UInt32 = 0
        let methods = class_copyMethodList(cls, &methodNum)
        for index in 0..<numericCast(methodNum) {
            let met: Method = methods![index]
            debugPrint("m_name: \(method_getName(met))" + " |==| " + "m_type: \(String(utf8String: method_getTypeEncoding(met)!)!)")
            //            debugPrint("m_returnType: \(String(utf8String: method_copyReturnType(met))!)")
            //            debugPrint("m_type: \(String(utf8String: method_getTypeEncoding(met))!)")
        }
        
        debugPrint("属性=========================================================")
        var propNum: UInt32 = 0
        let properties = class_copyPropertyList(cls, &propNum)
        for index in 0..<Int(propNum) {
            let prop: objc_property_t = properties![index]
            debugPrint("p_name: \(String(utf8String: property_getName(prop))!)")
            //            debugPrint("p_Attr: \(String(utf8String: property_getAttributes(prop))!)")
        }
        
        debugPrint("成员变量======================================================")
        var ivarNum: UInt32 = 0
        let ivars = class_copyIvarList(cls, &ivarNum)
        for index in 0..<numericCast(ivarNum) {
            let ivar: objc_property_t = ivars![index]
            let name = ivar_getName(ivar)
            let type = ivar_getTypeEncoding(ivar);
            //            NSLog(@"成员变量名：%s 成员变量类型：%s",name,type);
            debugPrint("ivar_name: \(String(cString: name!))" + " |==| " + "ivar_type: \(String(cString: type!))")
        }
    }
    
    /**
     - parameter cls: : 当前类
     - parameter originalSelector: : 原方法
     - parameter swizzledSelector: : 要交换的方法
     */
    /// RunTime交换方法
    class func mg_SwitchMethod(cls: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
        
        let originalMethod = class_getInstanceMethod(cls, originalSelector)
        let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector)
        
        let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
        
        if didAddMethod {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!);
        }
    }
}
