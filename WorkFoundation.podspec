target 'MyApp' do |s|

	s.name         = "WorkFoundation"
	s.version      = "0.1"
	s.summary      = "WorkFoundation Develpoe iOS Library."
	s.homepage     = "https://github.com/MenThu/WorkFoundation"
	s.platform     = :ios, '8.0'
	s.author    = { "MenThu" => "422729946@qq.com" }

	s.source       = { :git => "https://github.com/MenThu/WorkFoundation.git" }

	s.requires_arc = true
	s.source_files = 'WorkFoundation/**/*.{h,m,framework,a}'

	s.ios.vendored_frameworks = 'WorkFoundation/XHSoundRecorder/lame.framework'

	s.ios.vendored_libraries = 'libopencore-amrnb', 'libopencore-amrwb'

	s.dependency 'AFNetworking'
	s.dependency 'MJExtension'
	s.dependency 'MJRefresh'
	s.dependency 'YYKit'
	s.dependency 'SDWebImage'
	s.dependency 'Masonry'
	s.dependency 'MBProgressHUD'
end
