# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end

target 'xsh' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'SnapKit','4.2.0' #自动布局 http://www.hangge.com/blog/cache/detail_1097.html
  pod 'Kingfisher','4.10.1' #图片处理 http://www.jianshu.com/p/fa2624ac1959
  pod 'Alamofire','4.9.1'#网络请求
  pod 'AlamofireObjectMapper','5.2.1'
  pod 'SwiftyJSON','5.0.0'#字典转模型 http://www.hangge.com/blog/cache/detail_968.html
#  pod 'DGElasticPullToRefresh'#列表刷新 https://github.com/gontovnik/DGElasticPullToRefresh

  #极光推送
  pod 'JPush','3.4.0'
  #腾讯bugly，app异常检测
  pod 'Bugly','2.5.71'
  
  #百度地图 “, '~> 4.1.0'”
  #pod 'BaiduMapKit'
  pod 'BMKLocationKit','2.0.0'


  target 'xshTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'xshUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

