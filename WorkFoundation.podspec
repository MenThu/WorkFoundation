Pod::Spec.new do |s|

  s.name         = "WorkFoundation"
  s.version      = "0.1"
  s.summary      = "WorkFoundation Develpoe iOS Library."
  s.homepage     = "https://github.com/MenThu/WorkFoundation"
  #s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.platform     = :ios, '7.0'
  s.author    = { "MenThu" => "422729946@qq.com" }

  s.source       = { :git => "https://github.com/MenThu/WorkFoundation.git" }

  s.requires_arc = true
  s.source_files = 'WorkFoundation/**/*.{h,m,framework,a,mp3,mp4}'
  #s.public_header_files = 'WorkFoundation/**/*.{h}'

  s.ios.vendored_frameworks = 'WorkFoundation/XHSoundRecorder/lame.framework'

  #s.libraries = 'libopencore-amrnb', 'libopencore-amrwb'
  s.ios.vendored_libraries = 'libopencore-amrnb', 'libopencore-amrwb'

  s.dependency 'AFNetworking'
  s.dependency 'MJExtension'
  s.dependency 'MJRefresh'
  s.dependency 'YYKit'
  s.dependency 'SDWebImage'
  s.dependency 'Masonry'
  #s.dependency 'SVProgressHUD'
  s.dependency 'MBProgressHUD'
end
