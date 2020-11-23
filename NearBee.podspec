Pod::Spec.new do |s|
  s.name         = 'NearBee'
  s.swift_version = '5.0'
  s.version      = '0.4.5-beta1'
  s.summary      = 'iOS library for Eddystone beacons'

  s.homepage     = 'https://github.com/Beaconstac/NearBee-iOS-SDK'
  s.authors      = { 'MobStac Inc.' => 'support@beaconstac.com' }

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.source       = { :git => 'https://github.com/Beaconstac/NearBee-iOS-SDK.git', :tag => "v#{s.version}" }

  s.platform     = :ios, '10.0'

  s.preserve_paths = 'NearBee/*.a'

  s.source_files = 'NearBee/*.{h, swift}'
  s.ios.vendored_library = 'NearBee/*.a'
  s.preserve_paths = 'NearBee/*.a'
  s.ios.library = 'NearBee'
  s.resource = 'NearBee/NearBeeResources.bundle'
  s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)' }

  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  
  s.dependency 'EddystoneScanner'
  s.dependency 'Socket.IO-Client-Swift'
end
