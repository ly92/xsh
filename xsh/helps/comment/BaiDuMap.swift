//
//  BaiDuMap.swift
//  xsh
//
//  Created by 李勇 on 2019/1/17.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit

class BaiDuMap: NSObject {
    //单例
    static let `default` = BaiDuMap()
    
    
    fileprivate let locationManager = BMKLocationManager()
    fileprivate var haveAlert = false
    fileprivate var location = BMKLocation()
    
    func startLocation() {
        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: KBmapKey, authDelegate: self)
        
        self.locationManager.delegate = self
        //设置返回位置的坐标系类型
        self.locationManager.coordinateType = .BMK09LL
        //设置距离过滤参数
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //设置应用位置类型
        self.locationManager.activityType = .automotiveNavigation
        //设置是否自动停止位置更新
        self.locationManager.pausesLocationUpdatesAutomatically = false
        //设置是否允许后台定位
        //_locationManager.allowsBackgroundLocationUpdates = YES
        //设置位置获取超时时间
        self.locationManager.locationTimeout = 10
        //设置获取地址信息超时时间
        self.locationManager.reGeocodeTimeout = 10
        
        self.requestLocation()
    }
    
    func requestLocation() {
        self.locationManager.requestLocation(withReGeocode: true, withNetworkState: true) { (location, netState, error) in
            if error != nil{
                if error!._code == 2 || error!._code == 3 {
                    LYAlertView.show("提示", "请检查网络或者定位服务是否开启", "取消", "去设置", {
                        //打开设置页面
                        let url = URL(string : UIApplication.openSettingsURLString)
                        if UIApplication.shared.canOpenURL(url!){
                            UIApplication.shared.openURL(url!)
                        }
                    })
                }else{
                    LYAlertView.show("提示", "定位失败！是否重试", "取消", "重试", {
                        self.requestLocation()
                    })
                }
                /**
                 BMKLocationErrorUnKnown = 0,                   ///<未知异常
                 BMKLocationErrorLocFailed = 1,                 ///<位置未知，持续定位中
                 BMKLocationErrorDenied = 2,                    ///<手机不允许定位，请确认用户授予定位权限或者手机是否打开定位开关
                 BMKLocationErrorNetWork = 3,                   ///<因为网络原因导致系统定位失败
                 BMKLocationErrorHeadingFailed = 4,             ///<获取手机方向信息失败
                 BMKLocationErrorGetExtraNetworkFailed  = 5,    ///<网络原因导致获取额外信息（地址、网络状态等信息）失败
                 BMKLocationErrorGetExtraParseFailed  = 6,      ///<网络返回数据解析失败导致获取额外信息（地址、网络状态等信息）失败
                 BMKLocationErrorFailureAuth  = 7,              ///<鉴权失败导致无法返回定位、地址等信息
                 */
            }
            if location != nil{
                self.location = location!
            }
        }
    }
    
    
    
    func getUserLocal() -> CLLocationCoordinate2D {
        let def = CLLocationCoordinate2D.init(latitude: 39.728246, longitude: 115.984743)//燕山
//        let def = CLLocationCoordinate2D.init(latitude: 37.322135, longitude: 128.387898)//朝鲜
//        return def
        return self.location.location?.coordinate ?? def
    }

}


//MARK: - BMKLocationServiceDelegate
extension BaiDuMap : BMKLocationManagerDelegate, BMKLocationAuthDelegate{
    
    
    
    
//    func didUpdate(_ userLocation: BMKUserLocation!) {
//        //记录位置
//        self.location = userLocation
//
//        if !LocalData.getUserId().isEmpty{
//            let params : [String : Any] = [
//                "longitude" : userLocation.location.coordinate.longitude,
//                "latitude" : userLocation.location.coordinate.latitude
//            ]
//            NetTools.requestData(type: .get, urlString: UpdateUserLocationApi,parameters: params, succeed: { (result, msg) in
//            }) { (error) in
//            }
//        }
//        //停止定位
//        self.locationService.stopUserLocationService()
//    }
//
//    func didFailToLocateUserWithError(_ error: Error!) {
//        LYAlertView.show("提示", "请检查网络或者定位服务是否开启", "取消", "去设置", {
//            //打开设置页面
//            let url = URL(string:UIApplicationOpenSettingsURLString)
//            if UIApplication.shared.canOpenURL(url!){
//                UIApplication.shared.openURL(url!)
//            }
//        })
//    }
//
}

