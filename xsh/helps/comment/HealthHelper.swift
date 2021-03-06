//
//  HealthHelper.swift
//  xsh
//
//  Created by ly on 2019/1/24.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import CoreMotion

class HealthHelper: NSObject {
    //单例
//    static let `default` = HealthHelper()
    
    let steper = CMPedometer()
    fileprivate var stepsBlock : ((Int) ->Void)?
    
    //请求步数数据
    func requestStep(_ date : Date, _ block : @escaping ((Int) ->Void)) {
        if !CMPedometer.isStepCountingAvailable(){
            LYProgressHUD.showError("该设备不支持 获取步数 功能！")
            return
        }
        self.stepsBlock = block

        self.getStep(date)
        
    }
    
    //某时间当天 获取步数
    func getStep(_ date : Date) {
        
//        let calender = Calendar.current
//        let components = Set([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second])
//        let dateComponent = calender.dateComponents(components, from: date)
//        let hour = dateComponent.hour ?? 0
//        let minute = dateComponent.minute ?? 0
//        let second = dateComponent.second ?? 0
        
        let hour = date.hour()
        let minute = date.minute()
        let second = date.second()
        
        
        
        // 获取系统时区
        let zone:TimeZone = TimeZone.current
        // 计算本地时区与 GMT 时区的时间差 28800
        let scal = zone.secondsFromGMT()
        
        
//        print("---------------------------------------------------------------")
//
//        print("---------------------------------------------------------------")
//
        
        let start_time = date.phpTimestamp().intValue - hour * 3600 - minute * 60 - second - scal
        let end_time = start_time + 86399
        
        
        let date_start = Date.timestampToDate(Double(start_time))
        let date_end = Date.timestampToDate(Double(end_time))
//
//        print("---------------------------------------------------------------")
//        print(date_start)
//        print(date_end)
//        print("---------------------------------------------------------------")
//
        
        self.steper.queryPedometerData(from: date_start, to: date_end) { (pedometerData, error) in
            if error != nil{
//                LYProgressHUD.showError(error.debugDescription)
                if self.stepsBlock != nil{
                    self.stepsBlock!(-1)
                }
            }else if (pedometerData != nil){
                let step = pedometerData!.numberOfSteps.intValue
//                print(pedometerData?.currentPace ?? "123")
//                print(pedometerData?.averageActivePace ?? "1")
                
                
                if self.stepsBlock != nil{
                    self.stepsBlock!(step)
                }
            }
            
        }
    }
    
    
    
}
