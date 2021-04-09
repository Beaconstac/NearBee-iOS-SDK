Pod::Spec.new do |s|
  s.name         = 'NearBee'
  s.swift_version = '5.3'
  s.version      = '3.2.12'
  s.summary      = 'iOS library for Eddystone beacons'

  s.homepage     = 'https://github.com/Beaconstac/NearBee-iOS-SDK'
  s.authors      = { 'MobStac Inc.' => 'support@beaconstac.com' }

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.source       = { :git => 'https://github.com/Beaconstac/NearBee-iOS-SDK.git', :tag => "v#{s.version}" }

  s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '$(TOOLCHAIN_DIR)/usr/lib/swift/$(PLATFORM_NAME)' }

  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

  s.vendored_frameworks = 'NearBee/NearBee.framework'

  s.dependency 'EddystoneScanner'
  s.dependency 'Socket.IO-Client-Swift', '15.2.0'

  s.frameworks = 'CoreData', 'SystemConfiguration', 'CoreBluetooth', 'CoreLocation', 'UserNotifications', 'SafariServices'

  s.requires_arc = true
  s.ios.deployment_target = "10.0"
end
