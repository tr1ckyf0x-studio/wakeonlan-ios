# frozen_string_literal: true

require 'PodHelper/podfile_helper'

# Constants

DEPLOYMENT_TARGET = 13.0

# Suppresses warning 'Your project does not explicitly specify the CocoaPods master specs repo'
install! 'cocoapods', :warn_for_unused_master_specs_repo => false

use_frameworks! :linkage => :static
platform :ios, DEPLOYMENT_TARGET.to_s
project 'Wake on LAN.xcodeproj'
workspace 'Wake on LAN'

# Features
def features
    feature_module(name: 'AboutScreen')
    feature_module(name: 'AddHost')
    feature_module(name: 'DonateScreen')
    feature_module(name: 'HostList')
    feature_module(name: 'PostLaunch')
end

# Frameworks
def frameworks
    core_data_service
    framework_module(name: 'IAPManager')
    framework_module(name: 'SharedExtensions')
    framework_module(name: 'SharedProtocolsAndModels')
    framework_module(name: 'SharedRouter')
    framework_module(name: 'WOLResources')
    framework_module(name: 'WOLUIComponents')
    wol_service
end

# External dependencies
def external_frameworks
    external_framework(name: 'CocoaLumberjack/Swift', version: '3.8.4')
    external_framework(name: 'FirebaseAnalytics/WithoutAdIdSupport', version: '10.21.0')
    external_framework(name: 'FirebaseCrashlytics', version: '10.21.0')
    external_framework_git(name: 'ReachabilitySwift', source: 'https://github.com/ashleymills/Reachability.swift.git', version: 'v5.2.0')
    external_framework(name: 'RouteComposer', version: '2.10.5')
    external_framework_git(name: 'SnapKit', source: 'https://github.com/SnapKit/SnapKit.git', version: '5.7.0')
end

def core_data_service
    framework_module(name: 'CoreDataService')
end

def wol_service
    framework_module(name: 'WakeOnLanService')
end

# Targets
target 'Wake on LAN' do
    external_frameworks
    features
    frameworks
end

target 'Intent' do
    core_data_service
    wol_service
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end
