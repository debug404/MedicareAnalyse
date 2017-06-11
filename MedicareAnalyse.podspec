Pod::Spec.new do |s|

	s.framework  = "Foundation"
    s.name         = 'MedicareAnalyse'
    s.version      = '1.0.0'
    s.summary      = 'MedicareAnalyse'
    s.homepage     = 'https://github.com/debug404/MedicareAnalyse'
    s.description = <<-DESC
                       用于记录应用中的日志，包括启动日志，点击日志，页面访问日志，崩溃日志，行为日志，以及个性化的自定义日志。
                       DESC
    s.license      = 'MIT'
    s.authors      = {"debug404" => "leon9402@live.com"}
    s.platform     = :ios, '8.0'

    s.source       = {:git => 'https://github.com/debug404/MedicareAnalyse.git', :commit => "99cff488592af7fe692ee2cb4d7ffac21a556880", :tag => s.version}

    s.source_files = 'MedicareAnalyse/MedicareAnalyse/**/*.{h,m}'

    #s.resource     = 'Mytest/Mytest.bundle'
    s.requires_arc = true
end