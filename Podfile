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

  pod 'SnapKit' #自动布局 http://www.hangge.com/blog/cache/detail_1097.html
  pod 'Kingfisher' #图片处理 http://www.jianshu.com/p/fa2624ac1959
  pod 'Alamofire'#网络请求
  pod 'AlamofireObjectMapper'
  pod 'SwiftyJSON'#字典转模型 http://www.hangge.com/blog/cache/detail_968.html
#  pod 'ESPullToRefresh'#列表刷新

  #极光推送
#  pod 'JPush'
  #下载
#  pod 'ZFDownload'

  #腾讯bugly，app异常检测
  pod 'Bugly'

  target 'xshTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'xshUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
