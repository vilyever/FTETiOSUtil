Pod::Spec.new do |s|
    s.name             = "VDUtil"
    s.version          = "9.9.9"
    s.summary          = "Some uesful utils for iOS."
    s.description      = <<-DESC
                       It is some utils used on iOS, which implement by Objective-C.
                       DESC
    s.homepage         = "https://github.com/vilyever/FTETiOSUtil"
    s.license          = 'MIT'
    s.author           = { "Vilyever" => "vilyever@gmail.com" }
    s.source           = { :git => "https://github.com/vilyever/FTETiOSUtil.git", :tag => s.version.to_s }

    s.platform     = :ios, '5.0'
    s.requires_arc = true

    s.public_header_files = ['VDUtil/Pod/**/*.{h}']
    s.source_files = ['VDUtil/Pod/Classes/**/*.{h,m}']
    s.resources    = ['VDUtil/Pod/Resources/*', 'VDUtil/Pod/Classes/**/*.{xib}']

    s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit', 'QuartzCore'

    s.dependency 'VDKit', '9.9.9'
    s.dependency 'ReactiveCocoa', '2.0'
    s.dependency 'Aspects', '1.4.1'
    s.dependency 'CocoaLumberjack', '2.0.0-beta4'
    s.dependency 'POP+MCAnimate', '2.0.1'
    s.dependency 'Masonry', '0.6.0'
    s.dependency 'MBProgressHUD', '0.9'
    s.dependency 'AFNetworking', '2.5.0'
    s.dependency 'CocoaAsyncSocket', '7.4.1'
    s.dependency 'SDWebImage', '3.7.2'
    s.dependency 'FMDB', '2.4'
    s.dependency 'Shimmer', '1.0.2'
    s.dependency 'FLAnimatedImage', '1.0.7'
    s.dependency 'KMCGeigerCounter', '0.2.0'

end
