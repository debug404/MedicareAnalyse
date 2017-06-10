Pod::Spec.new do |s|

	s.framework  = "Foundation"
    s.name         = 'MedicareAnalyse'
    s.version      = '1.0.0'
    s.summary      = 'An easy way to use pull-to-refresh'
    s.homepage     = 'https://github.com/CoderMJLee/MJRefresh'
    s.license      = 'MIT'
    s.authors      = {"debug404" => "leon9402@live.com"}
    s.platform     = :ios, '8.0'
    s.source       = {:git => 'git => "https://github.com/debug404/MedicareAnalyse.git', :tag => s.version}
    s.source_files = 'MedicareAnalyse/**/*.{h,m}'
    #s.resource     = 'Mytest/Mytest.bundle'
    s.requires_arc = true
end