//
//  NetTools.swift
//  xsh
//
//  Created by 李勇 on 2018/12/13.
//  Copyright © 2018年 wwzb. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON

enum MethodType : String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

class NetTools: NSObject {
    //请求时间
    var elapsedTime: TimeInterval?
    
    //MARK: - 请求通用的manager
    static let defManager: SessionManager = {
        var defheaders = Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders
        let defConf = URLSessionConfiguration.default
        defConf.timeoutIntervalForRequest = 15
        defConf.httpAdditionalHeaders = defheaders
        return Alamofire.SessionManager(configuration: defConf)
    }()
    
    //MARK: - 后台请求用的manager
    static let backgroundManager: SessionManager = {
        let headers = Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders
        let backgroundConf = URLSessionConfiguration.background(withIdentifier: String(format:"%@.background",[Bundle.main.bundleIdentifier]))
        backgroundConf.httpAdditionalHeaders = headers
        return Alamofire.SessionManager(configuration: backgroundConf)
    }()
    
    //MARK: - 私有会话的manager
    static let ephemeralManager: SessionManager = {
        let headers = Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders
        let ephemeralConf = URLSessionConfiguration.ephemeral
        ephemeralConf.timeoutIntervalForRequest = 8
        ephemeralConf.httpAdditionalHeaders = headers
        return Alamofire.SessionManager(configuration: ephemeralConf)
    }()
    
    //检测网络
    class func checkNetType() -> Bool {
        guard let reachabilityManager = NetworkReachabilityManager.init(host: "www.7xiaofu.com")else{
            return false
        }
        return reachabilityManager.isReachable
    }
    class func checkNetTypeWiFi() -> Bool {
        guard let reachabilityManager = NetworkReachabilityManager.init(host: "www.7xiaofu.com")else{
            return false
        }
        return reachabilityManager.isReachableOnEthernetOrWiFi
    }
    class func checkNetTypeWWAN() -> Bool {
        guard let reachabilityManager = NetworkReachabilityManager.init(host: "www.7xiaofu.com")else{
            return false
        }
        return reachabilityManager.isReachableOnWWAN
    }
}

//通用请求方法
extension NetTools{
    
    /// 通用获取数据请求
    ///
    /// - Parameters:
    ///   - type: 请求类型
    ///   - urlString: 请求地址
    ///   - parameters: 请求参数
    ///   - succeed: 请求成功时回调
    ///   - failure: 请求失败时回调
    static func requestData(type: MethodType, urlString: String, parameters: [String : Any]? = nil, succeed: @escaping((_ result: JSON) -> Swift.Void), failure: @escaping((_ error: String) -> Swift.Void)){
        /**
         cid:用户id
         
         ts：时间戳
         sign：签名md5(cid+ts+cmdno+passwd)
         cmdno：
         */
        var ts = Date.phpTimestamp()
        var cmdno = String.randomStr(len: 20) + ts
        if parameters != nil{
            if parameters!.keys.contains("ts"){
                ts = parameters!["ts"] as! String
            }
            if parameters!.keys.contains("cmdno"){
                cmdno = parameters!["cmdno"] as! String
            }
        }
        
        let sign = (LocalData.getCId() + ts + cmdno + LocalData.getPwd()).md5String()
        
        //1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        //2.设置请求头
        let headers : HTTPHeaders = [
            "osType": "ios",
            "token": ts
        ]
        
        //3.拼接默认参数
        var param : [String : Any]
        if parameters == nil{
            param = [String : Any]()
        }else{
            param = parameters!
        }
        param["ts"] = ts
        param["sign"] = sign
        param["cmdno"] = cmdno
        param["cid"] = LocalData.getCId()
        
        //4.拼接url
        let URL = usedServer + urlString.trim
        
        #if DEBUG
        var strs : Array<String> = Array<String>()
        for key in param.keys {
            let value  = param[key]
            strs.append(key + "=" + "\(value ?? "")")
        }
        let str = strs.joined(separator: "&")
        debugPrint("-----------URL--------")
        if URL.contains("?"){
            debugPrint(URL + "&" + str)
        }else{
            debugPrint(URL + "?" + str)
        }
        #endif
        
        //5.获取网络请求
        NetTools.defManager.request(URL, method: method, parameters: param, encoding: URLEncoding.default, headers:headers).responseJSON { (respose) in
            //请求成功
            if respose.result.isSuccess{
                
                let json = JSON(respose.result.value ?? ["error":"未请求到数据"])
                #if DEBUG
                debugPrint("-----------返回数据--------")
                debugPrint(json)
                #endif
                
                
                if json["code"].stringValue == "0"{
                    //返回正确结果
                    succeed(json["content"])
                }else if json["code"].stringValue == "1228" || json["code"].stringValue == "1227"{
                    guard let nav = AppDelegate.sharedInstance.tabBar.selectedViewController as? LYNavigationController else{
                        return
                    }
                    let loginVC = LoginViewController.spwan()
                    if #available(iOS 13.0, *) {
                        loginVC.modalPresentationStyle = .fullScreen
                    } else {
                        // Fallback on earlier versions
                    }
                    nav.viewControllers.first?.present(loginVC, animated: true) {
                        LocalData.saveYesOrNotValue(value: "0", key: KIsLoginKey)
                    }
                }else{
                    failure( json["message"].stringValue)
                }
                
            }
            
            //请求失败
            if respose.result.isFailure{
                #if DEBUG
                debugPrint("-----------错误数据--------")
                debugPrint(URL + "&" + str)
//                debugPrint(respose.result.error ?? "请求失败！")
                #endif
                failure(respose.result.error as? String ?? "数据获取失败,请重试！")
            }
        }
    }
    
    static func requestDataWithImage(type: MethodType, urlString: String, imgArray: Array<UIImage>, imageName: String, parameters: [String : String], succeed: @escaping((_ result: JSON) -> Swift.Void), failure: @escaping((_ error: String) -> Swift.Void)){
        /**
         cid:用户id
         ts：时间戳
         sign：签名md5(cid+ts+cmdno+passwd)
         cmdno：
         */
        let ts = Date.phpTimestamp()
        let cmdno = String.randomStr(len: 20) + ts
        let sign = (LocalData.getCId() + ts + cmdno + LocalData.getPwd()).md5String()
        
        //2.设置请求头
        let headers : HTTPHeaders = [
            "osType": "ios",
            "Content-Type" : "multipart/form-data",
            "form-data" : "file"
        ]
        let url = usedServer + urlString
        NetTools.defManager.upload(
            multipartFormData: { multipartFormData in
                for i in 0..<imgArray.count{
                    let image = imgArray[i]
                    let imageData = self.resetImgSize(sourceImage: image, maxImageLenght: 500, maxSizeKB: 450)
                    multipartFormData.append(imageData, withName: "image", fileName: "temp.jpeg", mimeType: "image/jpeg")
                }
                
                multipartFormData.append(ts.data(using: .utf8)!, withName: "ts")
                multipartFormData.append(sign.data(using: .utf8)!, withName: "sign")
                multipartFormData.append(cmdno.data(using: .utf8)!, withName: "cmdno")
                multipartFormData.append(LocalData.getCId().data(using: .utf8)!, withName: "cid")
                for key in parameters.keys{
                    multipartFormData.append(parameters[key]!.data(using: .utf8)!, withName: key)
                }
        },
            to: url,
            method: HTTPMethod.post,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: { (response) in
                        let json = JSON(response.result.value ?? ["error":"未请求到数据"])
                        debugPrint(json)
                        succeed(json["content"])
                    })
                case .failure(let encodingError):
                    failure("\(encodingError)")
                    debugPrint(encodingError)
                }
        })
    }
    //上传头像
    static func upLoadImage(urlString: String, imgArray: Array<UIImage>,success : @escaping((_ result: JSON) -> Swift.Void), failture : @escaping (_ error : String)->()){
        /**
         cid:用户id
         ts：时间戳
         sign：签名md5(cid+ts+cmdno+passwd)
         cmdno：
         */
        let ts = Date.phpTimestamp()
        let cmdno = String.randomStr(len: 20) + ts
        let sign = (LocalData.getCId() + ts + cmdno + LocalData.getPwd()).md5String()
        
        //2.设置请求头
        let headers : HTTPHeaders = [
            "osType": "ios",
            "Content-Type" : "multipart/form-data",
            "form-data" : "file"
        ]
        let url = usedServer + urlString
        NetTools.defManager.upload(
            multipartFormData: { multipartFormData in
                for i in 0..<imgArray.count{
                    let image = imgArray[i]
                    let imageData = self.resetImgSize(sourceImage: image, maxImageLenght: 500, maxSizeKB: 450)
                    multipartFormData.append(imageData, withName: "iconurl", fileName: "temp.jpeg", mimeType: "image/jpeg")
                }
                
                multipartFormData.append(ts.data(using: .utf8)!, withName: "ts")
                multipartFormData.append(sign.data(using: .utf8)!, withName: "sign")
                multipartFormData.append(cmdno.data(using: .utf8)!, withName: "cmdno")
                multipartFormData.append(LocalData.getCId().data(using: .utf8)!, withName: "cid")
        },
            to: url,
            method: HTTPMethod.post,
            headers: headers,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON(completionHandler: { (response) in
                        let json = JSON(response.result.value ?? ["error":"未请求到数据"])
                        debugPrint(json)
                        success(json["content"])
                    })
                case .failure(let encodingError):
                    failture("\(encodingError)")
                    debugPrint(encodingError)
                }
        })
    }
    
    
    
    
    //登录
    static func normalRequest(type: MethodType, urlString: String, parameters: [String : Any], succeed: @escaping((_ result: JSON) -> Swift.Void), failure: @escaping((_ error: String) -> Swift.Void)){
        
        //1.获取类型
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        //2.设置请求头
        let headers : HTTPHeaders = [:]
        //4.拼接url
        let URL = usedServer + urlString.trim
        
        #if DEBUG
        var strs : Array<String> = Array<String>()
        for key in parameters.keys {
            let value  = parameters[key]
            strs.append(key + "=" + "\(value ?? "")")
        }
        let str = strs.joined(separator: "&")
        debugPrint("-----------URL--------")
        if URL.contains("?"){
            debugPrint(URL + "&" + str)
        }else{
            debugPrint(URL + "?" + str)
        }
        #endif
        
        //5.获取网络请求
        NetTools.defManager.request(URL, method: method, parameters: parameters, encoding: URLEncoding.default, headers:headers).responseJSON { (respose) in
            //请求成功
            if respose.result.isSuccess{
                
                let json = JSON(respose.result.value ?? ["error":"未请求到数据"])
                #if DEBUG
                debugPrint("-----------返回数据--------")
                debugPrint(json)
                #endif
                
                
                if json["code"].stringValue != "0"{
                    failure( json["message"].stringValue)
                    return
                }
                
                //返回正确结果
                succeed(json["content"])
            }
            
            //请求失败
            if respose.result.isFailure{
                #if DEBUG
                debugPrint("-----------错误数据--------")
                debugPrint(respose.result.error ?? "请求失败！")
                #endif
                failure(respose.result.error as? String ?? "数据获取失败,请重试！")
            }
        }
    }
    
    class func resetImgSize(sourceImage : UIImage,maxImageLenght : CGFloat,maxSizeKB : CGFloat) -> Data {
        var maxSize = maxSizeKB
        var maxImageSize = maxImageLenght
        if (maxSize <= 0.0) {
            maxSize = 1024.0;
        }
        if (maxImageSize <= 0.0)  {
            maxImageSize = 1024.0;
        }
        
        //先调整分辨率
        var newSize = CGSize.init(width: sourceImage.size.width, height: sourceImage.size.height)
        let tempHeight = newSize.height / maxImageSize;
        let tempWidth = newSize.width / maxImageSize;
        if (tempWidth > 1.0 && tempWidth > tempHeight) {
            newSize = CGSize.init(width: sourceImage.size.width / tempWidth, height: sourceImage.size.height / tempWidth)
        }
        else if (tempHeight > 1.0 && tempWidth < tempHeight){
            newSize = CGSize.init(width: sourceImage.size.width / tempHeight, height: sourceImage.size.height / tempHeight)
        }
        
        UIGraphicsBeginImageContext(newSize)
        
        sourceImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        var imageData = newImage!.jpegData(compressionQuality: 1.0)
        var sizeOriginKB : CGFloat = CGFloat((imageData?.count)!) / 1024.0;
        //调整大小
        var resizeRate = 0.9;
        while (sizeOriginKB > maxSize && resizeRate > 0.1) {
            
            imageData = newImage!.jpegData(compressionQuality: CGFloat(resizeRate))
            sizeOriginKB = CGFloat((imageData?.count)!) / 1024.0;
            resizeRate -= 0.1;
        }
        return imageData!
    }
    
    static func zipImage(currentImage: UIImage,scaleSize:CGFloat,percent: CGFloat) -> Data?{
        
        //压缩图片尺寸
        UIGraphicsBeginImageContext(CGSize.init(width: currentImage.size.width*scaleSize, height: currentImage.size.height*scaleSize))
        currentImage.draw(in: CGRect(x: 0, y: 0, width: currentImage.size.width*scaleSize, height:currentImage.size.height*scaleSize))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //高保真压缩图片质量
        //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
        let imageData = newImage.jpegData(compressionQuality: percent)
        return imageData
    }
    
    
    
}


extension NetTools{
    
    /*1.通过请求头告诉服务器，客户端的类型（可以通过修改，欺骗服务器）*/
    class func HeadRequest()
    {
        //(1）设置请求路径
        let url:NSURL = NSURL(string:"http://www.7xiaofu.com/api/index.php?act=login&op=index")!//不需要传递参数
        
        //(2) 创建请求对象
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url as URL) //默认为get请求
        request.timeoutInterval = 5.0 //设置请求超时为5秒
        request.httpMethod = "POST"  //设置请求方法
        
        let token_time = String(format:"%0.f",Date().timeIntervalSince1970 * 1000)
        //                let token_time = Date.phpTimestamp()
        var token = ("qixiaofu0ab3b4n55nca" + token_time)
        token = token.md5String()
        
        //设置请求体
        let param:NSString = NSString(format:"username=18612334016&password=e3ceb5881a0a1fdaad01296d7554868d&client=ios&token=%@&token_time=%@",token,token_time)
        //把拼接后的字符串转换为data，设置请求体
        request.httpBody = param.data(using: String.Encoding.utf8.rawValue)
        
        //客户端类型，只能写英文
        request.setValue("android", forHTTPHeaderField:"osType")
        request.setValue(token, forHTTPHeaderField:"token")
        
        //(3) 发送请求
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue:OperationQueue()) { (res, data, error)in
            //服务器返回：请求方式 = POST，返回数据格式 = JSON，用户名 = 123，密码 = 123
            let  str = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
            debugPrint(str!)
        }
    }
    
    class func requestDataTest(urlString: String, parameters: [String : Any]? = nil, succeed: @escaping((_ result: JSON) -> Swift.Void), failure: @escaping((_ error: String?) -> Swift.Void))
    {
        
        let token_time = Date.phpTimestamp()
        var token = ("qixiaofu0ab3b4n55nca" + token_time)
        token = token.md5String()
        //3.拼接默认参数
        var param : [String : Any]
        if parameters == nil{
            param = [String : Any]()
        }else{
            param = parameters!
        }
        param["token"] = token
        param["token_time"] = token_time
        
        
        //4.拼接url
        let URL = usedServer + urlString
        
        var strs : Array<String> = Array<String>()
        for key in param.keys {
            let value  = param[key]
            strs.append(key + "=" + "\(value ?? "")")
        }
        let str = strs.joined(separator: "&")
        debugPrint("-----------URL--------")
        if URL.contains("?"){
            debugPrint(URL + "&" + str)
        }else{
            debugPrint(URL + "?" + str)
        }
        
        //(2) 创建请求对象
        let request:NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string:URL)! as URL) //默认为get请求
        request.timeoutInterval = 10.0 //设置请求超时为5秒
        request.httpMethod = "POST"  //设置请求方法
        
        
        //设置请求体
        let param222:NSString = NSString(format:str as NSString)
        //把拼接后的字符串转换为data，设置请求体
        request.httpBody = param222.data(using: String.Encoding.utf8.rawValue)
        
        //客户端类型，只能写英文
        request.setValue("android", forHTTPHeaderField:"osType")
        request.setValue(token, forHTTPHeaderField:"token")
        
        //(3) 发送请求
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue:OperationQueue()) { (res, data, error)in
            debugPrint("----------返回数据-----------")
            //服务器返回：请求方式 = POST，返回数据格式 = JSON，用户名 = 123，密码 = 123
            let  str = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
            debugPrint(str!)
        }
    }
    
    
    class func requestCustom(urlString: String, parameters: [String : Any]? = nil, succeed: @escaping((_ result: JSON) -> Swift.Void), failure: @escaping((_ error: String?) -> Swift.Void))
    {
        
        //(2) 创建请求对象
        let url = URL.init(string: urlString)
        if url == nil{
            
        }
        var request = URLRequest.init(url: url!)
        request.timeoutInterval = 10.0
        request.httpMethod = HTTPMethod.post.rawValue
        if parameters != nil{
            var strs : Array<String> = Array<String>()
            for key in parameters!.keys {
                let value  = parameters![key]
                strs.append(key + "=" + "\(value ?? "")")
            }
            let str = strs.joined(separator: "&")
            debugPrint("-----------URL--------")
            debugPrint(urlString + "?" + str)
            //设置请求体
            let param222:NSString = NSString(format:str as NSString)
            //把拼接后的字符串转换为data，设置请求体
            request.httpBody = param222.data(using: String.Encoding.utf8.rawValue)
        }
        
        request.addValue("8091945", forHTTPHeaderField: "CaAppId")
        
        //(3) 发送请求
//        NSURLConnection.sendAsynchronousRequest(request, queue:OperationQueue()) { (res, data, error)in
//            //服务器返回：请求方式 = POST，返回数据格式 = JSON，用户名 = 123，密码 = 123
//            let  str = NSString(data: data!, encoding:String.Encoding.utf8.rawValue)
//            debugPrint(str!)
//        }

//        let sessionConfigure = URLSessionConfiguration.default
//        sessionConfigure.httpAdditionalHeaders = ["Content-Type": "application/json"]
//        sessionConfigure.timeoutIntervalForRequest = 30
//        sessionConfigure.requestCachePolicy = .reloadIgnoringLocalCacheData
//        let session = URLSession(configuration: sessionConfigure)
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            debugPrint(data ?? "data null")
            
            if data != nil{
                let result = JSON(data!)
                if result.type == .null{
                    failure("获取数据失败！")
                }else{
                    succeed(result)
                }
                debugPrint("-----------返回数据--------")
                debugPrint(result)
            }else{
                debugPrint("-----------错误数据--------")
                debugPrint(error ?? "获取数据失败")
                failure("获取数据失败！")
            }
        }
        dataTask.resume()
    }
    
}

