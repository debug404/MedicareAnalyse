Pod::Spec.new do |s|

	s.frameworks    = 'Foundation','CoreLocation'
    #s.libraries     = 'libsqlite3.tbd'
    s.libraries     = 'sqlite3'
    s.name         = 'MedicareAnalyse'
    s.version      = '1.0.1'
    s.summary      = 'MedicareAnalyse'
    s.homepage     = 'https://github.com/debug404/MedicareAnalyse'
    s.description = <<-DESC
                       用于记录应用中的日志，包括启动日志，点击日志，页面访问日志，崩溃日志，行为日志，以及个性化的自定义日志。
                       DESC
    s.license      = 'MIT'
    s.authors      = {"debug404" => "leon9402@live.com"}
    s.platform     = :ios, '8.0'

    s.source       = {:git => 'https://github.com/debug404/MedicareAnalyse.git', :commit => "4fb684fd8c5d9a3c0e9082c6ce13fc8cfae3c02f", :tag => s.version}

    s.source_files = 'MedicareAnalyse/MedicareAnalyse/**/*.{h,m}'

    #s.resource     = 'Mytest/Mytest.bundle'
    s.requires_arc = true
end