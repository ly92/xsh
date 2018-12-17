//
//  NetApis.swift
//  xsh
//
//  Created by 李勇 on 2018/12/13.
//  Copyright © 2018年 wwzb. All rights reserved.
//

import UIKit
class NetApis: NSObject {
    
}
//屏幕尺寸
let kScreenSize = UIScreen.main.bounds.size
let kScreenW = UIScreen.main.bounds.width
let kScreenH = UIScreen.main.bounds.height





let officialServer = "http://star.test.wwwcity.net/app/"//正式服务器
let testServer = "http://star.test.wwwcity.net/app/"//测试服务器
let usedServer = officialServer
//let usedServer = testServer
let DeBug = false


/************************************ 登录&注册 ********************************************/

//获取验证码
let GetCodeApi = "user/smscode"//post mobile,isnew:是否检查已注册，0不检查，1检查
//注册
let RegisterApi = "user/add" //post mobile,nickname,passwd,code
//登录
let LoginApi = "user/login"//post mobile,ts:时间戳,sign:sign=md5(mobile+ts+passwd),device:设备的push token
//设备校验
let CheckTokenApi = "user/checktoken"//post device
//修改密码
let ChangePwdApi = "user/updatepwd" //post id,oldpasswd,newpasswd
//修改密码-忘记密码
let ForgetPwdApi = "user/resetpwd" // post mobile,code,passwd
//获取个人信息
let GetPersonalInfoApi = "user/get" //post id
//修改个人信息
let ChangePersonalInfoApi = "user/modify" //post cid,nickname, communityid:所在小区id
//修改手机号
let ChangePhoneApi = "user/mobile" //post cid:用户内部id，mobile:手机号，code:验证码，passwd:验证密码md5(md5(密码)+手机号)


/************************************ 功能栏 ********************************************/
//首页功能栏
let FunctionListApi = "module/list"//post userId
//更多功能栏
let FunctionMoreListApi = "module/more"// post userId


/************************************ 消息 ********************************************/
//统计未读消息
let MessageNewCountApi = "message/new"//post
//消息列表
let MessageListApi = "message/search"// post type:消息类型id，默认0则全部,lastid:列表按id倒序 最大id 默认0,skip:忽略记录数 默认0, limit:最大记录数 默认10
//消息详情
let MessageDetailApi = "message/get"// post id
//全部标记已读
let MessageAllReadApi = "message/allread"// post


/************************************ 广告公告 ********************************************/
//查询广告位广告列表
let AdListApi = "ads/list" //post location:广告位, skip, limit
//查询广告位广告详情
let AdDetailApi = "ads/get" //post id
//公告列表接口
let NoticeListApi = "notice/list"//post skip, limit
//公告详情
let NoticeDetailApi = "notice/get"//post id




