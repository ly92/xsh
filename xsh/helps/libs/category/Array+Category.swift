//
//  Array+Category.swift
//  qixiaofu
//
//  Created by ly on 2017/7/12.
//  Copyright © 2017年 qixiaofu. All rights reserved.
//

import Foundation

extension Array{
    func jsonString() -> String {
        let data = try?JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
        if data != nil{
            let str = String.init(data: data!, encoding: .utf8)
            if str != nil{
                return str!
            }
        }
        return ""
    }

    
    
}
