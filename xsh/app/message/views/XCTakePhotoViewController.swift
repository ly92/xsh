//
//  XCTakePhotoViewController.swift
//  xsh
//
//  Created by 李勇 on 2019/12/24.
//  Copyright © 2019 wwzb. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class XCTakePhotoViewController: BaseViewController {
    class func spwan() -> XCTakePhotoViewController{
        return self.loadFromStoryBoard(storyBoard: "Message") as! XCTakePhotoViewController
    }
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var pickView: UIPickerView!
    
    fileprivate let communities = ["健德一里 ","健德二里 ","健德三里 ","健德四里 "]
    fileprivate let buildings1 = ["1号楼 ","2号楼 ","3号楼 ","4号楼 ","5号楼 ","6号楼 ","7号楼 ","8号楼 ","9号楼 ","10号楼 ","11号楼 ","12号楼 ","13号楼 ","14号楼 ","15号楼 ","16号楼 ","17号楼 ","18号楼 ","19号楼 ","20号楼 ","21号楼 ","22号楼 ","23号楼 ","24号楼 ","25号楼 ","26号楼 ","27号楼 ","28号楼 ","29号楼 ","30号楼 ","31号楼 ","32号楼 ","33号楼 ","34号楼 ","35号楼 ","36号楼 ","37号楼 ","38号楼 ","39号楼 "]
    fileprivate let buildings2 = ["1号楼 ","2号楼 ","3号楼 ","4号楼 ","5号楼 ","6号楼 ","7号楼 ","8号楼 ","9号楼 ","10号楼 ","11号楼 ","12号楼 ","甲12号楼 ","13号楼 ","甲13号楼 ","14号楼 ","15号楼 ","16号楼 ","17号楼 ","18号楼 ","19号楼 ","20号楼 ","21号楼 ","22号楼 ","23号楼 ","24号楼 ","25号楼 ","26号楼 ","27号楼 ","28号楼 ","29号楼 ","30号楼 ","31号楼 ","32号楼 ","33号楼 ","34号楼 ","35号楼 ","36号楼 ","37号楼 ","38号楼 ","39号楼 ","40号楼 ","41号楼 "]
    fileprivate let buildings3 = ["1号楼 ","2号楼 ","3号楼 ","4号楼 ","5号楼 ","6号楼 ","7号楼 ","8号楼 ","9号楼 ","10号楼 ","11号楼 ","12号楼 ","13号楼 ","14号楼 ","15号楼 ","16号楼 ","17号楼 ","18号楼 ","19号楼 ","20号楼 ","21号楼 ","22号楼 ","23号楼 ","24号楼 ","25号楼 ","26号楼 ","27号楼 ","28号楼 ","29号楼 ","30号楼 ","31号楼 ","32号楼 ","33号楼 ","34号楼 ","35号楼 "]
    fileprivate let buildings4 = ["1号楼 ","2号楼 ","3号楼 ","4号楼 ","5号楼 ","6号楼 ","7号楼 ","8号楼 ","9号楼 ","10号楼 ","11号楼 ","12号楼 ","13号楼 ","14号楼 ","甲14号楼 ","15号楼 ","16号楼 ","甲16号楼 ","17号楼 ","18号楼 ","甲18号楼 ","19号楼 ","20号楼 ","21号楼 ","22号楼 ","23号楼 ","24号楼 ","25号楼 ","26号楼 ","27号楼 ","28号楼 ","29号楼 ","30号楼 "]
    fileprivate let unities = ["1单元","2单元","3单元","4单元","5单元","6单元","7单元","8单元","9单元","10单元","11单元","12单元","13单元","14单元","15单元"]
    
    fileprivate var selectedC = 0
    fileprivate var selectedB = 0
    fileprivate var selectedU = 0
    fileprivate var imgTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "照片采集"
        
    }
    
    
    @IBAction func takePhoto() {
        self.camera()
    }
    

}


extension XCTakePhotoViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
            return 4
        }else if component == 1{
            if self.selectedC == 0{
                return self.buildings1.count
            }else if self.selectedC == 1{
                return self.buildings2.count
            }else if self.selectedC == 2{
                return self.buildings3.count
            }else if self.selectedC == 3{
                return self.buildings4.count
            }
        }else if component == 2{
            return 15
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0{
            if self.communities.count > row{
                return self.communities[row]
            }
        }else if component == 1{
            if self.selectedC == 0{
                if self.buildings1.count > row{
                    return self.buildings1[row]
                }
            }else if self.selectedC == 1{
                if self.buildings2.count > row{
                    return self.buildings2[row]
                }
            }else if self.selectedC == 2{
                if self.buildings3.count > row{
                    return self.buildings3[row]
                }
            }else if self.selectedC == 3{
                if self.buildings4.count > row{
                    return self.buildings4[row]
                }
            }
        }else if component == 2{
            if self.unities.count > row{
                return self.unities[row]
            }
        }
        return "无效选项"
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 25
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            self.selectedC = row
            self.selectedB = 0
            pickerView.selectRow(0, inComponent: 1, animated: true)
            self.selectedU = 0
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }else if component == 1{
            self.selectedB = row
            self.selectedU = 0
            pickerView.selectRow(0, inComponent: 2, animated: true)
        }else if component == 2{
            self.selectedU = row
        }
        
        var building = ""
        if self.selectedC == 0{
            building = self.buildings1[self.selectedB]
        }else if self.selectedC == 1{
            building = self.buildings2[self.selectedB]
        }else if self.selectedC == 2{
            building = self.buildings3[self.selectedB]
        }else if self.selectedC == 3{
            building = self.buildings4[self.selectedB]
        }
                
        self.imgTitle = self.communities[self.selectedC] + building + self.unities[self.selectedU]
        
        print(self.imgTitle)
    }
}

extension XCTakePhotoViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
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
        self.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            LYProgressHUD.showError("选中错误，请重试！")
            return
        }
        
        let image = img.drawTextInImage(text: self.imgTitle, textColor: UIColor.red, textFont: UIFont.systemFont(ofSize: 150.0), suffixText: nil, suffixFont: nil, suffixColor: nil)
        
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }) { (isSuccess: Bool, error: Error?) in
            if isSuccess {
                LYProgressHUD.showSuccess("保存成功")
            } else{
                LYProgressHUD.showError(error!.localizedDescription)
            }
        }
       
    }


    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}



extension UIImage{
    /// 图片加水印
    ///
    /// - Parameters:
    ///   - text: 水印完整文字
    ///   - textColor: 文字颜色
    ///   - textFont: 文字大小
    ///   - suffixText: 尾缀文字(如果是nil可以不传)
    ///   - suffixFont: 尾缀文字大小(如果是nil可以不传)
    ///   - suffixColor: 尾缀文字颜色(如果是nil可以不传)
    /// - Returns: 水印图片
    func drawTextInImage(text: String, textColor: UIColor, textFont: UIFont,suffixText: String?, suffixFont: UIFont?, suffixColor: UIColor?) -> UIImage {
        // 开启和原图一样大小的上下文（保证图片不模糊的方法）
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        // 图形重绘
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        var suffixAttr: [NSAttributedString.Key: Any] = [NSAttributedString.Key.foregroundColor:textColor, NSAttributedString.Key.font:textFont]
        let attrS = NSMutableAttributedString(string: text, attributes: suffixAttr)
        
        // 添加后缀的属性字符串
        if let suffixStr = suffixText {
            let range = NSRange(location: text.count - suffixStr.count, length: suffixStr.count)
            if suffixFont != nil {
                suffixAttr[NSAttributedString.Key.font] = suffixFont
            }
            
            if suffixColor != nil {
                suffixAttr[NSAttributedString.Key.foregroundColor] = suffixColor
            }
            attrS.addAttributes(suffixAttr, range: range)
        }
        
        // 文字属性
        let size =  attrS.size()
//        let x = (self.size.width - size.width) / 2
//        let y = (self.size.height - size.height) / 2
        let x = 100
        let y = self.size.height - size.height - 100
        
        // 绘制文字
        attrS.draw(in: CGRect(x: CGFloat(x), y: y, width: size.width, height: size.height))
        // 从当前上下文获取图片
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
    }
}
