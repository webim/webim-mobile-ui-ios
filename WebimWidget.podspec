Pod::Spec.new do |s|
  s.name             = 'WebimWidget'
  s.version          = '1.0.0'
  s.summary          = 'Webim.ru mobile UI for client SDK iOS.'

  s.homepage         = 'https://webim.ru/integration/mobile-sdk/ios-sdk-howto/'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Webim.ru Ltd' => 'dev@webim.ru' }
  s.source           = { :git =>
'https://github.com/webim/webim-mobile-ui-ios.git', :tag => s.version.to_s 
}
  s.ios.deployment_target = '10.0'
  s.resource_bundles = {
      'WebimWidget-Assets' => ['WebimWidget/**/*.{xcassets,json}'],
  }
  s.resources = 'Sources/WebimWidget/Assets/**/*.{xcassets,json}'
  s.source_files = 'Sources/**/*.{swift,strings,xib}'
  s.dependency 'WebimClientLibrary', '~> 3.14'
  s.dependency 'Cosmos', '~> 19.0.3'
  s.dependency 'Nuke', '~> 8.0'
  s.dependency 'SnapKit'
end
