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




let officialServer = "http://star.wwwcity.net/app/"//正式服务器
let testServer = "http://star.test.wwwcity.net/app/"//测试服务器
//let testServer = "http://star.pos.wwwcity.net/app/"//测试服务器
//let testServer2 = "http://xing.com/app/"//测试服务器
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
let ChangeLoginPwdApi = "user/updatepwd" //post id,oldpasswd,newpasswd
//修改密码-忘记密码
let ForgetPwdApi = "user/resetpwd" // post mobile,code,passwd
//获取个人信息
let GetPersonalInfoApi = "user/get" //post id
//修改个人信息
let ChangePersonalInfoApi = "user/modify" //post cid,nickname,gender,idcard,areaid, communityid:所在小区id
//修改头像
let ChangePersonIconApi = "user/iconurl" // post iconurl
//修改手机号
let ChangePhoneApi = "user/mobile" //post cid:用户内部id，mobile:手机号，code:验证码，passwd:验证密码md5(md5(密码)+手机号)
//查询最新版本
let CheckVersionApi = "ver" //post platform:终端类型

//获取地区列表
let AreaListApi = "area/list" //post
//获取小区列表
let CommunityListApi = "community/list"//post areaid


/************************************ 功能栏 ********************************************/
//首页功能栏
let FunctionListApi = "module/list"//post userId
//更多功能栏
let FunctionMoreListApi = "module/more"// post userId
//积分兑换规则
let StepTransPointRuleApi = "stepsOpt" // post
//打卡记录
let StepsLogListApi = "user/stepsLog" // post skip limit
//运动步数转积分
let StepTransToPointApi = "user/steps" // post steps sign_date
//功能栏点击统计
let ClickFuncStatisticsApi = "AccessLog/addAccessLogById"// post access_log_type_id platform

/************************************ 优惠券 ********************************************/
//领券中心
let CouponListApi = "coupon/syslist"// post skip limit
//我的优惠券列表
let MyCouponListApi = "coupon/userlist"// post userid bizid：对应商家
//领取优惠券
let CouponGetApi = "coupon/sysissue"//post optid userid
//优惠券详情
let CouponDetailApi = "coupon/detail" //post id

/************************************ 消息 ********************************************/
//统计未读消息
let MessageNewCountApi = "message/new"//post
//消息列表
let MessageListApi = "message/search"// post type:消息类型id，默认0则全部,lastid:列表按id倒序 最大id 默认0,skip:忽略记录数 默认0, limit:最大记录数 默认10
//消息详情
let MessageDetailApi = "message/get"// post id
//全部标记已读
let MessageAllReadApi = "message/allread"// post
//删除
let MessageDeleteApi = "message/delete" // post ids

/************************************ 广告公告 ********************************************/
//查询广告位广告列表
let AdListApi = "ads/list" //post location:广告位, skip, limit
//查询广告位广告详情
let AdDetailApi = "ads/get" //post id
//公告列表接口
let NoticeListApi = "notice/list"//post skip, limit
//公告详情
let NoticeDetailApi = "notice/get"//post id
//启动广告
let AdLaunchApi = "ads/last" //post location:广告位


/************************************ 一卡通 ********************************************/
//检查是否开通
let CheckCardApi = "card/check" // post
//开通一卡通
let OpenCardApi = "card/open" // post passwd
//绑定实体卡
let BindCardApi = "card/bindHardCard" // post cardno, code, passwd
//一卡通详情
let CardDetailApi = "card/get" // post
//修改支付密码
let CardChangePwdApi = "user/updatePaypwd" // post oldpasswd, newpasswd
//重置支付密码
let CardResetPayPwdApi = "user/resetPaypwd" // post paypsw, passwd
//一卡通交易记录
let CardOrderListApi = "card/listTransaction" // post starttime, stoptime, skip, limit
//创建交易
let ShopAddOrderApi = "transaction/order" // post money,bid,servicetype
//查询充值方式
let CardRechargeTypeApi = "card/depositType" // post
//充值
let CardRechargeApi = "card/order" // post , money
//支付方式
let PayTypeApi = "transaction/paytype" //post orderno
//创建预付单
let PrePayOrderApi = "transaction/prepay" // post ptid:支付方式,atid:货币ID,orgaccount:付款账户,destaccount:收款账户,orderno:订单号,money:付款金额,points:积分抵消费金额,coupons:使用优惠券，逗号分隔优惠券码
//取消预支付单
let CancelPrePayOrderApi = "transaction/cancel"//post orderno
//一卡通支付
let CardPayApi = "transaction/pay" //post paysign:md5(cid + ts + cmdno + paypsw),orderno
//缴费详情
let PayOrderDetailApi = "pay/get" //post UUID orderno
//检查支付密码
let CheckPwdApi = "transaction/checkpwd" // post paysign md5(cid+ts+cmdno+passwd)
//一卡通交易列表
let CardTransactionListApi = "transaction/list" // post
//一卡通交易详情
let CardTransactionDetailApi = "transaction/get" // post orderno
//订单评价
let EvaluateOrderApi = "productionEvaluate/create" // post orderno evaluateJson
//积分总数
let GetPointsApi = "points/get" //post
//积分流水
let PointsListApi = "points/list" // post type:1: 支出 其他：收入  month:月数
//获取一卡通支付二维码
let CardCodeApi = "card/qrcode" // post
/************************************ 一卡通 ********************************************/
//首页推荐商品
let RecommendGoodsApi = "shop/recommend" //post

/************************************ 商家 ********************************************/
//获取商家列表
let StoreListApi = "biz/getBizSortList"
//获取所有行业
let StoreIndustryApi = "biz/industryall"


/************************************ 投诉 建议 维修 ********************************************/
//小区列表
let HouseListApi = "maintain/getunit"//post
//创建投诉&建议
let CreateComplantSuggestApi = "complain/apply"// post communityid:小区编号  type：类型 content：维修内容 image：配图地址 username：用户名 mobile：联系电话 address：联系地址
//根据cid获取投诉&建议列表
let ComplantSuggestListApi = "complain/listuncomments"// post
//评价投诉建议
let EvaluateComplantApi = "complain/comments"// post comments:是否满意 1同意 2不同意 reason原因
//创建维修
let CreateRepairApi = "maintain/apply" // post communityid:小区编号  maintype：主维修类型 subtype：子维修类型 content：维修内容 image：配图地址 username：用户名 mobile：联系电话 address：联系地址 unit：报修单元
//根据cid获取维修列表
let RepairListApi = "maintain/listuncomments" // post
//评价维修
let EvaluateRepairApi = "maintain/comments"// post id:维修编号 comments：是否满意 1满意 2不满意 reason：原因
//维修类型列表
let RepairCategoryApi = "maintain/subtypes" // post maintype 1公共维修，2个人维修
