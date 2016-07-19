
Pod::Spec.new do |s|

  s.name         = "WorkFoundation"
  s.version      = "0.1"
  s.summary      = "My WorkFoundation"
  s.homepage     = "https://github.com/MenThu/WorkFoundation"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.platform     = :ios, '7.0'
  s.author       = { "MenThu" => "422729946@qq.com" }

  s.source       = { :git => "https://github.com/MenThu/WorkFoundation.git"}

  s.requires_arc = true
  s.source_files = 'BM4Group/**/*.{h,m}'
  s.public_header_files = 'BM4Group/**/*.{h}'

  #s.ios.vendored_frameworks = 'Vendor/Reveal.framework'

  s.dependency 'BRCocoaLumberjack'
  s.dependency 'IQKeyboardManager'
  s.dependency 'DZNEmptyDataSet'
  s.dependency 'SVProgressHUD'
  s.dependency 'AFNetworking'
  s.dependency 'MJExtension'
  s.dependency 'MJRefresh'
  s.dependency 'YYKit'

end
