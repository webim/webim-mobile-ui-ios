Pod::Spec.new do |s|
  s.name             = 'WebimMobileWidget'
  s.version          = '1.3.9'
  s.summary          = 'Webim.ru mobile UI for client SDK iOS.'

  s.homepage         = 'https://webim.ru/integration/mobile-sdk/ios-sdk-howto/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Webim.ru Ltd' => 'webimdev@gmail.com' }
  s.source           = { :git => 'https://github.com/webim/webim-mobile-ui-ios.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.swift_version = '5.5'
  s.source_files = 'Sources/WebimMobileWidget/Classes/**/*.{swift,strings}'
  s.resources = 'Sources/WebimMobileWidget/Assets/**/*.{xib,strings}',
  'Sources/WebimMobileWidget/Assets/WidgetImages.xcassets'
  s.dependency 'WebimMobileSDK', '~> 3.42.0'
  s.dependency 'WebimKeyboard', '~> 1.0.3'
  s.dependency 'Cosmos', '~> 25.0.1'
  s.dependency 'Nuke'
  s.dependency 'FLAnimatedImage', '~> 1.0'
  s.dependency 'SnapKit'
end
