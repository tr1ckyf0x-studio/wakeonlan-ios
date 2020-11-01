platform :ios, '12.0'

target 'Wake on LAN' do
  use_frameworks!

  pod "Resolver"
  pod "R.swift"
  pod 'Firebase/Analytics'
  pod 'Firebase/Crashlytics'

  target 'WakeOnLanTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
end
