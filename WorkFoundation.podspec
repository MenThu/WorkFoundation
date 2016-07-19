
Pod::Spec.new do |s|

  
  s.name         = "WorkFoundation"
  s.version      = "0.2"
  s.summary      = "My WorkFoundation"
  s.homepage     = "https://github.com/MenThu/WorkFoundation"
  s.license      = { :type => 'MIT' }
  s.platform     = :ios, '7.0'
  s.author       = { "MenThu" => "422729946@qq.com" }

  s.source       = { :git => "https://github.com/MenThu/WorkFoundation.git", :tag=>s.version.to_s}  

  s.requires_arc = true
  s.source_files = 'WorkFoundation/**/*.{h,m}'
  #s.public_header_files = 'WorkFoundation/**/*.{h}'

  s.dependency 'AFNetworking'
  s.dependency 'MJExtension'
  s.dependency 'MJRefresh'


end
