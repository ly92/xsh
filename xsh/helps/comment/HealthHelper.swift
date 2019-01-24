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
    static let `default` = HealthHelper()
    
    let healthStore = HKHealthStore()
    
    //请求步数数据
    func requestStep() {
        if !HKHealthStore.isHealthDataAvailable(){
            LYProgressHUD.showError("该设备不支持 健康 功能！")
            return
        }
        
        //设置需要获取的权限这里仅设置了步数
        guard let healthType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let healthSet = Set([healthType])
        
        self.healthStore.requestAuthorization(toShare: nil, read: healthSet) { (success, error) in
            if success {
                self.getStep()
            }else{
                //失败
                LYProgressHUD.showInfo("未允许访问健康数据，请您设置App允许访问健康数据！")
            }
        }
    }
    
    //获取步数
    func getStep() {
        let time = Date.dateStringFromDate(format: Date.dateFormatString(), timeStamps: Date.dateYesterday().phpTimestamp())
        
        if LocalData.getYesOrNotValue(key: time){
            return
        }
        
        
        guard let sampleType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        
        let now = Date()
        let calender = Calendar.current
        let components = Set([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second])
        let dateComponent = calender.dateComponents(components, from: now)
        let hour = dateComponent.hour ?? 0
        let minute = dateComponent.minute ?? 0
        let second = dateComponent.second ?? 0
        let yesterDay = Date.init(timeIntervalSinceNow: TimeInterval(-(86400 + hour * 3600 + minute * 60 + second)))
        let nowDay = Date.init(timeIntervalSinceNow: TimeInterval( -hour * 3600 - minute * 60 - second))
        let predicate = HKQuery.predicateForSamples(withStart: yesterDay, end: nowDay, options: [HKQueryOptions.init(rawValue: 0)])

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

                if count > 0{
                    let desc = "您昨日共有\(count)步可兑换为积分,明日不可兑换昨日步数"
                    LYAlertView.show("步数换积分", desc, "暂不兑换", "立即兑换", {
                        var params : [String : Any] = [:]
                        params["steps"] = count
                        params["sign_date"] = time
                        NetTools.requestData(type: .post, urlString: StepTransToPointApi, parameters: params, succeed: { (result) in
                            LYProgressHUD.showSuccess("转换成功！")
                            LocalData.saveYesOrNotValue(value: "1", key: time)
                        }) { (error) in
                            LYProgressHUD.showError(error)
                        }
                    })
                }
                
            }
        }
        self.healthStore.execute(sampleQuery)
        
    }
    
    

    
    
}
