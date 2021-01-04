//
//  TakeOnePhotoHelper.swift
//  xsh
//
//  Created by ly on 2019/1/29.
//  Copyright © 2019年 wwzb. All rights reserved.
//

import UIKit
import AVFoundation
import Photos



class TakeOnePhotoHelper: NSObject {
    //单例
    static let `default` = TakeOnePhotoHelper()
    fileprivate var vc = UIViewController()
    fileprivate var takePhotoBlock : ((UIImage) -> Void)?
    
    
    func takePhoto(_ vc : UIViewController, _ block : @escaping ((UIImage) -> Void)) {
        self.vc = vc
        self.takePhotoBlock = block
        
        self.takePhotoAction()
    }

    //选择方式
    func takePhotoAction() {
        let rechargeAlert = UIAlertController.init(title: "选择图片", message: "", preferredStyle: .actionSheet)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel) { (action) in
        }
        let camera = UIAlertAction.init(title: "拍照", style: .default) { (action) in
            //相机
            self.camera()
        }
        let album = UIAlertAction.init(title: "相册", style: .default) { (action) in
            //相册
            self.photoAlbum()
        }
        rechargeAlert.addAction(camera)
        rechargeAlert.addAction(album)
        rechargeAlert.addAction(cancel)
        
        self.vc.present(rechargeAlert, animated: true, completion: nil)
    }
}



extension TakeOnePhotoHelper : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    //相机
    func camera() {
        //是否允许使用相机
        switch AVCaptureDevice.authorizationStatus(for: AVMediaType.video) {
        case .restricted,.denied:
            LYAlertView.show("提示", "请允许App使用相机权限", "取消", "去设置", {
                //打开设置页面
                let url = URL(string:UIApplication.openSettingsURLString)
                if UIApplication.shared.canOpenURL(url!){
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
            })
            return
        case .authorized,.notDetermined:
            break
        }
        
        //是否有相机设备
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            LYProgressHUD.showError("此设备无拍照功能!!!")
            return
        }
        //后置与前置摄影头均不可用
        if !UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.rear) && !UIImagePickerController.isCameraDeviceAvailable(UIImagePickerController.CameraDevice.front){
            LYProgressHUD.showError("相机不可用!!!")
            return
        }
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        self.vc.present(picker, animated: true, completion: nil)
    }
    
    //相册
    func photoAlbum() {
        
        //是否允许使用相册
        switch PHPhotoLibrary.authorizationStatus() {
        case .restricted,.denied:
            LYAlertView.show("提示", "请允许App访问相册", "取消", "去设置", {
                //打开设置页面
                let url = URL(string:UIApplication.openSettingsURLString)
                if UIApplication.shared.canOpenURL(url!){
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                }
            })
            break
        case .authorized,.notDetermined,.limited:
            break
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker : UIImagePickerController = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            picker.navigationBar.tintColor = UIColor.RGBS(s: 33)
            self.vc.present(picker, animated: true, completion: nil)
        }else{
            LYProgressHUD.showError("不允许访问相册")
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            LYProgressHUD.showError("选中错误，请重试！")
            return
        }
        
        if self.takePhotoBlock != nil{
            self.takePhotoBlock!(img)
        }
    }


    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
