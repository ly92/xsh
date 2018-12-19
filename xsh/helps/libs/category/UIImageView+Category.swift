//
//  UIImageView+Category.swift
//  qixiaofu
//
//  Created by ly on 2017/8/15.
//  Copyright © 2017年 qixiaofu. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView{

    func setImageUrlStr(_ str : String){
        self.kf.setImage(with: URL(string:str), placeholder: #imageLiteral(resourceName: "placeholder_app"), options: nil, progressBlock: nil, completionHandler: nil)
    
       
    }
    
    func setHeadImageUrlStr(_ str : String){
        self.kf.setImage(with: URL(string:str), placeholder: #imageLiteral(resourceName: "header"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    func setImageUrlStrAndPlaceholderImg(_ str : String, _ pImg : UIImage) {
        self.kf.setImage(with: URL(string:str), placeholder: pImg, options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    static func createQrcodeWithImage(_ image : UIImage, _ url : String) -> UIImage?{
        let qrImg = self.createQrcode(url)
        if qrImg != nil{
            //开启上下文
            UIGraphicsBeginImageContext(qrImg!.size)
            //把二维码画到上下文
            qrImg!.draw(in: CGRect.init(origin: CGPoint.zero, size: qrImg!.size))
            
            //把前景图画到二维码上
            let w :CGFloat = 80
            image.draw(in: CGRect.init(x: (qrImg!.size.width - w) * 0.5, y: (qrImg!.size.height - w) * 0.5, width: w, height: w))
            
            //获取新图片
            let newImg = UIGraphicsGetImageFromCurrentImageContext()
            
            //关闭上下文
            UIGraphicsEndImageContext()
            
            return newImg
        }
        
        return qrImg
    }
    
    static func createQrcode(_ url : String) -> UIImage? {
        //1.创建一个二维码滤镜实例(CIFilter)
        let filter = CIFilter.init(name: "CIQRCodeGenerator")
        // 滤镜恢复默认设置
        filter?.setDefaults()
        
        //2.给滤镜添加数据
        guard let data = url.data(using: String.Encoding.utf8) else {
            return nil
        }
        filter?.setValue(data, forKey: "inputMessage")
        
        //3.生成二维码
        guard let ciImg = filter?.outputImage else {
            return nil
        }
        
        //4.调整清晰度
        //创建Transform
        let scale = kScreenW / ciImg.extent.width
        let transform = CGAffineTransform.init(scaleX: scale, y: scale)
        //放大图片
        let bigImg = ciImg.transformed(by: transform)
        
        return UIImage.init(ciImage: bigImg)
    }
}
