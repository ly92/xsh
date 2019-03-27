//
//  HealthHelper.swift
//  xsh
//
//  Created by ly on 2019/1/24.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import HealthKit

class HealthHelper: NSObject {
    //单例
//    static let `default` = HealthHelper()
    
    let healthStore = HKHealthStore()
    fileprivate var stepsBlock : ((Int) ->Void)?
    
    //请求步数数据
    func requestStep(_ date : Date, _ block : @escaping ((Int) ->Void)) {
        if !HKHealthStore.isHealthDataAvailable(){
            LYProgressHUD.showError("该设备不支持 健康 功能！")
            return
        }
        self.stepsBlock = block
        //设置需要获取的权限这里仅设置了步数
        guard let healthType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let healthSet = Set([healthType])
        
        self.healthStore.requestAuthorization(toShare: nil, read: healthSet) { (success, error) in
            if success {
                self.getStep(date)
            }else{
                //失败
                LYProgressHUD.showInfo("未允许访问健康数据，请您设置App允许访问健康数据！")
            }
        }
    }
    
    //某时间当天 获取步数
    func getStep(_ date : Date) {
        guard let sampleType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let calender = Calendar.current
        let components = Set([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second])
        let dateComponent = calender.dateComponents(components, from: date)
        let hour = dateComponent.hour ?? 0
        let minute = dateComponent.minute ?? 0
        let second = dateComponent.second ?? 0
        
        var start_time = date.phpTimestamp().intValue - hour * 3600 - minute * 60 - second
        var end_time = start_time + 86399
        
        if date.isToday(){
            start_time -= 8 * 3600
            end_time -= 8 * 3600
        }
        
        let date_start = Date.timestampToDate(Double(start_time))
        let date_end = Date.timestampToDate(Double(end_time))
        
        let predicate = HKQuery.predicateForSamples(withStart: date_start, end: date_end, options: [HKQueryOptions.init(rawValue: 0)])

        let start = NSSortDescriptor.init(key: HKSampleSortIdentifierStartDate, ascending: false)
        let end = NSSortDescriptor.init(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        
        let sampleQuery = HKSampleQuery.init(sampleType: sampleType, predicate: predicate, limit: 0, sortDescriptors: [start,end]) { (query, results, error) in
            if results != nil{
                var count = 0
                for temp in results!{
                    guard let result = temp as? HKQuantitySample else{
                        continue
                    }
                    let quantity = result.quantity
                    let step = quantity.description.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "count", with: "").intValue
                    count += step
                }
                
                if self.stepsBlock != nil{
                    self.stepsBlock!(count)
                }
            }
        }
        self.healthStore.execute(sampleQuery)
    }
    
    
    
}
