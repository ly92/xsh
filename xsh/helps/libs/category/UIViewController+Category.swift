//
//  UIViewController+Category.swift
//  qixiaofu
//
//  Created by 李勇 on 2017/6/5.
//  Copyright © 2017年 qixiaofu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    public class func loadFromStoryBoard(storyBoard : String) -> UIViewController{
        let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        let identifier = NSStringFromClass(self).replacingOccurrences(of: nameSpace + ".", with: "")
        
        let board = UIStoryboard.init(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: identifier)
     return board
    }
}
