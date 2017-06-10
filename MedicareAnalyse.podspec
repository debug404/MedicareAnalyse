Pod::Spec.new do |s|

	s.framework  = "Foundation"
    s.name         = 'MedicareAnalyse'
    s.version      = '1.0.0'
    s.summary      = 'An easy way to use pull-to-refresh'
    s.homepage     = 'https://github.com/CoderMJLee/MJRefresh'
    s.description = 'This library provides a category for UIImageView with support for remote '      \
                  'images coming from the web. It provides an UIImageView category adding web '    \
                  'image and cache management to the Cocoa Touch framework, an asynchronous '      \
                  'image downloader, an asynchronous memory + disk image caching with automatic '  \
                  'cache expiration handling, a guarantee that the same URL won\'t be downloaded ' \
                  'several times, a guarantee that bogus URLs won\'t be retried again and again, ' \
                  'and performances!'
    s.license      = 'MIT'
    s.authors      = {"debug404" => "leon9402@live.com"}
    s.platform     = :ios, '8.0'

    s.source       = {:git => 'https://github.com/debug404/MedicareAnalyse.git', :commit => "99cff488592af7fe692ee2cb4d7ffac21a556880", :tag => s.version}

    s.source_files = 'MedicareAnalyse/MedicareAnalyse/**/*.{h,m}'

    #s.resource     = 'Mytest/Mytest.bundle'
    s.requires_arc = true
end