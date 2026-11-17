Pod::Spec.new do |s|
  
  s.name         = "RNGosellSdkReactNative"
  s.version      = "1.0.9"
  s.summary      = "RNGosellSdkReactNative"
  s.description  = <<-DESC
                  RNGosellSdkReactNative
                   DESC
  s.homepage     = "https://github.com/Tap-Payments/gosellSDK-ReactNative"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  s.author             = { "author" => "author@domain.cn" }
  s.platform     = :ios, "15.0"
  s.swift_version = "5.0"
  s.source       = { :git => "https://github.com/Tap-Payments/gosellSDK-ReactNative.git", :tag => "master" }
  # s.source_files  = "RNGosellSdkReactNative/*/.{h,m}"
  s.source_files = 'ios/Classes/**/*'
  s.public_header_files = 'ios/Classes/**/*.h'
  s.requires_arc = true
  # goSellSDK comes from CocoaPods by default. Run `GOSELL_USE_SPM=1 pod install` to get it through
  # Swift Package Manager instead (needs React Native 0.75 or newer for `spm_dependency`).
  if ENV['GOSELL_USE_SPM'] == '1'
    unless defined?(spm_dependency)
      raise "GOSELL_USE_SPM=1 needs React Native 0.75 or newer (spm_dependency is not available)"
    end
    spm_dependency(s,
      url: 'https://github.com/Tap-Payments/goSellSDK-iOS.git',
      requirement: { kind: 'exactVersion', version: '2.4.1' },
      products: ['goSellSDK']
    )
  else
    s.dependency 'goSellSDK', '2.4.1'
  end
  s.dependency 'React-Core'

  # s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  # s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  # s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES'}
  # s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  #s.dependency "others"

end