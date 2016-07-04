Pod::Spec.new do |s|
    s.name             = "VDUtil"
    s.version          = "0.0.1"
    s.summary          = "Some uesful utils for iOS."
    s.description      = <<-DESC
                       It is some utils used on iOS, which implement by Objective-C.
                       DESC
    s.homepage         = "https://github.com/vilyever/VDKits"
    s.license          = 'MIT'
    s.author           = { "Vilyever" => "vilyever@gmail.com" }
    s.source           = { :path => '~/ResourceXcode/Vilyever/1.1.0/VDUtil' }

    s.platform     = :ios, '5.0'
    s.requires_arc = true

    s.public_header_files = ['VDUtil/pods/**/*.{h}']
    s.source_files = ['VDUtil/pods/Classes/*.{h,m}']
    s.resources    = ['VDUtil/pods/Resources/*']

    s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit', 'QuartzCore'

    s.dependency 'VDKit'
    s.dependency 'ReactiveCocoa'
    s.dependency 'Aspects'
    s.dependency 'CocoaLumberjack'
    s.dependency 'POP+MCAnimate'
    s.dependency 'Masonry'
    s.dependency 'MBProgressHUD'
    s.dependency 'Base64'
    s.dependency 'CocoaSecurity'
    s.dependency 'AFNetworking'
    s.dependency 'CocoaAsyncSocket'
    s.dependency 'SDWebImage'
    s.dependency 'FMDB'
    s.dependency 'Shimmer'
    s.dependency 'FLAnimatedImage'
    s.dependency 'KMCGeigerCounter'

    s.subspec 'Animation' do |ss|

        ss.source_files = ['VDUtil/pods/Classes/Animation/*.{h,m}']
        ss.resources    = ['VDUtil/pods/Classes/Animation/*.{xib}']

        ss.subspec 'UIView' do |sss|

            sss.source_files = ['VDUtil/pods/Classes/Animation/UIView/*.{h,m}']
            sss.resources = ['VDUtil/pods/Classes/Animation/UIView/*{xib}']

        end

        ss.subspec 'CALayer' do |sss|

            sss.source_files = ['VDUtil/pods/Classes/Animation/CALayer/*.{h,m}']
            sss.resources = ['VDUtil/pods/Classes/Animation/CALayer/*{xib}']

        end

    end

    s.subspec 'NSObject' do |ss|

        ss.source_files = ['VDUtil/pods/Classes/NSObject/*.{h,m}']
        ss.resources    = ['VDUtil/pods/Classes/NSObject/*.{xib}']

    end

    s.subspec 'UILabel' do |ss|

        ss.source_files = ['VDUtil/pods/Classes/UILabel/*.{h,m}']
        ss.resources    = ['VDUtil/pods/Classes/UILabel/*.{xib}']

    end

    s.subspec 'UITextView' do |ss|

        ss.source_files = ['VDUtil/pods/Classes/UITextView/*.{h,m}']
        ss.resources    = ['VDUtil/pods/Classes/UITextView/*.{xib}']

    end

    s.subspec 'UIImageView' do |ss|

        ss.source_files = ['VDUtil/pods/Classes/UIImageView/*.{h,m}']
        ss.resources    = ['VDUtil/pods/Classes/UIImageView/*.{xib}']

    end

    s.subspec 'UIView' do |ss|

        ss.source_files = ['VDUtil/pods/Classes/UIView/*.{h,m}']
        ss.resources    = ['VDUtil/pods/Classes/UIView/*.{xib}']

    end

    s.subspec 'UIButton' do |ss|

        ss.source_files = ['VDUtil/pods/Classes/UIButton/*.{h,m}']
        ss.resources    = ['VDUtil/pods/Classes/UIButton/*.{xib}']

    end

    s.subspec 'VDTextInput' do |ss|

        ss.source_files = ['VDUtil/pods/Classes/VDTextInput/*.{h,m}']
        ss.resources    = ['VDUtil/pods/Classes/VDTextInput/*.{xib}']

        ss.subspec 'KeyBoard' do |sss|

            sss.source_files = ['VDUtil/pods/Classes/VDTextInput/KeyBoard/*.{h,m}']
            sss.resources    = ['VDUtil/pods/Classes/VDTextInput/KeyBoard/*.{xib}']

        end

        ss.subspec 'UISearchBar' do |sss|

            sss.source_files = ['VDUtil/pods/Classes/VDTextInput/UISearchBar/*.{h,m}']
            sss.resources    = ['VDUtil/pods/Classes/VDTextInput/UISearchBar/*.{xib}']

        end

        ss.subspec 'UITextField' do |sss|

            sss.source_files = ['VDUtil/pods/Classes/VDTextInput/UITextField/*.{h,m}']
            sss.resources    = ['VDUtil/pods/Classes/VDTextInput/UITextField/*.{xib}']

        end

    end

end
