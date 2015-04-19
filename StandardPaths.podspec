Pod::Spec.new do |s|
  s.name         = "StandardPaths"
  s.version      = "1.6.4"
  s.summary      = "Category on NSFileManager for simple consistent access to standard application directories."
  s.description  = <<-DESC
                   StandardPaths is a category on `NSFileManager` for simplifying access to standard application directories on iOS and Mac OS and abstracting the iCloud backup flags on iOS.
                   It also provides support for working with device-specific file suffixes, such as the `@2x` suffix for Retina displays, or the `-568h` suffix for iPhone 5 and can optionally swizzle certain UIKit methods to support these suffixes more consistently.
                   DESC
  s.homepage     = "https://github.com/nicklockwood/StandardPaths"
  s.license      = "Zlib License"
  s.author       = { "Nick Lockwood" => "http://charcoaldesign.co.uk/" }
  s.social_media_url = "http://twitter.com/nicklockwood"
  s.ios.deployment_target = "4.3"
  s.osx.deployment_target = "10.6"
  s.source       = { :git => "https://github.com/nicklockwood/StandardPaths.git", :tag => s.version.to_s }
  s.source_files = "StandardPaths/"
  s.requires_arc = true
  s.default_subspecs = ['Swizzle']

  s.subspec 'Swizzle' do |ss|
  	ss.source_files = ''
  	ss.prefix_header_contents = '#define SP_SWIZZLE_ENABLED 1'
  end

  s.subspec 'NoSwizzle' do |ss|
  	ss.source_files = 'StandardPaths/'
  	ss.prefix_header_contents = '#define SP_SWIZZLE_ENABLED 0'
  end

end
