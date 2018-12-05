Pod::Spec.new do |s|
  s.name         = 'NearBee'
  s.swift_version = '4.2'
  s.version      = '0.0.1'
  s.summary      = 'iOS library for Eddystone beacons'

  s.homepage     = 'https://github.com/Beaconstac/NearBee-iOS-SDK'
  s.authors      = { 'MobStac Inc.' => 'support@beaconstac.com' }

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.source       = { :git => 'https://github.com/Beaconstac/NearBee-iOS-SDK.git', :tag => "v#{s.version}" }

  s.platform     = :ios, '10.0'
  
  s.source_files = 'NearBee/*.{h}'
  s.ios.vendored_library = 'NearBee/libNearBee.a'
  s.resource = 'NearBee/NearBeeResources.bundle'
  s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => "$(SRCROOT)/Pods/**" }

  s.dependency 'EddystoneScanner'
  s.dependency 'Socket.IO-Client-Swift'

  s.frameworks = 'CoreData', 'SystemConfiguration', 'CoreBluetooth', 'CoreLocation', 'UserNotifications', 'SafariServices'
  s.weak_framework = 'UIKit'

  s.ios.deployment_target = '10.0'
end
