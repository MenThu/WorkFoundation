
Pod::Spec.new do |s|

  s.source       = { :git => "https://github.com/MenThu/WorkFoundation.git"}
  s.name         = "WorkFoundation"
  s.version      = "0.1"
  s.summary      = "My WorkFoundation"
  s.homepage     = "https://github.com/MenThu/WorkFoundation"
  s.license      = { :type => 'MIT' }
  s.platform     = :ios, '7.0'
  s.author       = { "MenThu" => "422729946@qq.com" }

  

  s.requires_arc = true
  s.source_files = 'WorkFoundation/**/*.{h,m}'
  #s.public_header_files = 'WorkFoundation/**/*.{h}'

  s.dependency 'AFNetworking'
  s.dependency 'MJExtension'
  s.dependency 'MJRefresh'


end
