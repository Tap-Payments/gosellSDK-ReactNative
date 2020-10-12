
Pod::Spec.new do |s|
  s.name         = "RNGosellSdkReactNative"
  s.version      = "1.0.0"
  s.summary      = "RNGosellSdkReactNative"
  s.description  = <<-DESC
                  RNGosellSdkReactNative
                   DESC
  s.homepage     = ""
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/Tap-Payments/gosellSDK-ReactNative.git", :tag => "master" }
  s.source_files  = "RNGosellSdkReactNative/**/*.{h,m}"
  s.requires_arc = true
  s.dependency 'goSellSDK', '2.2.35'

  s.dependency "React"
  #s.dependency "others"

end

  