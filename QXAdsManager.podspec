#
# Be sure to run `pod lib lint QXAdsManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QXAdsManager'
  s.version          = '0.1.6'
  s.summary          = '广告管理'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/BIBiBI12/QXAdsManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'me_zqx' => 'me_zqx@163.com' }
  s.source           = { :git => 'https://github.com/BIBiBI12/QXAdsManager.git', :tag => s.version.to_s  }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'QXAdsManager/Classes/**/*'
  
  # s.public_header_files = 'Pod/Classes/**/*.h'
  
  s.resource_bundles = {
     'QXAdsManager' => ['QXAdsManager/Assets/*.bundle']
   }
   s.static_framework = true
  # 依赖第三方framework
  s.vendored_frameworks = ['QXAdsManager/Frameworks/BaiduMobAdSDK.framework',
                           'QXAdsManager/Frameworks/BUAdSDK.framework',
                           'QXAdsManager/Frameworks/GoogleAppMeasurement.framework',
                           'QXAdsManager/Frameworks/GoogleMobileAds.framework',
                           'QXAdsManager/Frameworks/GoogleUtilities.framework',
                           'QXAdsManager/Frameworks/InMobiSDK.framework',
                           'QXAdsManager/Frameworks/nanopb.framework',
                           'QXAdsManager/Frameworks/UnityAds.framework',
                           ]
  # 依赖第三方静态库 .a
  s.vendored_libraries  = 'QXAdsManager/Classes/GDTlib/*.{a}'

  # 依赖系统framworks  TODO - 私有引入有问题'CoreTelephony.'
  s.frameworks = 'UIKit', 'MapKit', 'WebKit', 'StoreKit', 'AVFoundation', 'AdSupport', 'CoreMotion', 'MessageUI', 'CoreLocation', 'SafariServices', 'CoreMedia', 'MediaPlayer' ,'SystemConfiguration', 'Security','QuartzCore'
  # 依赖系统lib TODO - Libc++
  s.libraries = 'sqlite3.0' ,'z','xml2','resolv.9','c++'

  # 依赖其他pod框架
  s.dependency 'Masonry', '~> 1.1.0'
  s.dependency 'YYWebImage', '~> 1.0.5'
  
end
