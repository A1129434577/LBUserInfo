Pod::Spec.new do |spec|
  spec.name         = "LBUserInfo"
  spec.version      = "0.0.2"
  spec.summary      = "用户基本信息快速缓存、获取类。。"
  spec.description  = "项目中用户基本信息快速缓存、获取类。"
  spec.homepage     = "https://github.com/A1129434577/LBUserInfo"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "刘彬" => "1129434577@qq.com" }
  spec.platform     = :ios
  spec.ios.deployment_target = '8.0'
  spec.source       = { :git => 'https://github.com/A1129434577/LBUserInfo.git', :tag => spec.version.to_s }
  spec.requires_arc = true
  

  #spec.default_subspec = 'LBUserModel'

  spec.subspec 'LBUserModel' do |ss|
    ss.source_files = "LBUserInfo/LBUserModel/**/*.{h,m}"
  end
  spec.subspec 'LBUserLocation' do |ss|
    ss.dependency 'LBUserInfo/LBUserModel'
    ss.source_files = "LBUserInfo/LBUserLocation/**/*.{h,m}"
  end
  spec.subspec 'LBUserTempOperateInfo' do |ss|
    ss.dependency 'LBUserInfo/LBUserModel'
    ss.source_files = "LBUserInfo/LBUserTempOperateInfo/**/*.{h,m}"
  end
end
