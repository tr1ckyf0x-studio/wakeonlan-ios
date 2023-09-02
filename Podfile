# frozen_string_literal: true

require_relative 'ruby-utils/cocoapods/podfile_helper'

# Constants

DEPLOYMENT_TARGET = 13.0 # TODO: Move to the global constants

use_frameworks! :linkage => :static
platform :ios, DEPLOYMENT_TARGET.to_s
project 'Wake on LAN.xcodeproj'
workspace 'Wake on LAN'

def core_data_service
    feature_module(name: 'CoreDataService', need_create_testspecs: false)
end

def wol_service
    feature_module(name: 'WakeOnLanService', need_create_testspecs: false)
end

# Feature Modules
def features
    feature_module(name: 'AboutScreen', need_create_testspecs: false)
    feature_module(name: 'AddHost', need_create_testspecs: false)
    core_data_service
    feature_module(name: 'DonateScreen', need_create_testspecs: false)
    feature_module(name: 'HostList', need_create_testspecs: false)
    feature_module(name: 'IAPManager', need_create_testspecs: false)
    feature_module(name: 'PostLaunch', need_create_testspecs: false)
    wol_service
end

# Frameworks
def frameworks
    framework_module(name: 'SharedExtensions', need_create_testspecs: false)
    framework_module(name: 'SharedProtocolsAndModels', need_create_testspecs: false)
    framework_module(name: 'SharedRouter', need_create_testspecs: false)
    framework_module(name: 'WOLResources', need_create_testspecs: false)
    framework_module(name: 'WOLUIComponents', need_create_testspecs: false)
end

# External dependencies
def external_frameworks
    external_framework(name: 'CocoaLumberjack/Swift', version: '3.8.1')
    external_framework(name: 'FirebaseAnalytics/WithoutAdIdSupport', version: '10.14.0')
    external_framework(name: 'FirebaseCrashlytics', version: '10.14.0')
    external_framework_git(name: 'ReachabilitySwift', source: 'https://github.com/ashleymills/Reachability.swift.git', version: 'v5.1.0')
    external_framework(name: 'RouteComposer', version: '2.10.4')
    external_framework(name: 'SnapKit', version: '5.6.0')
end

# Targets
target 'Wake on LAN' do
    external_frameworks
    features
    frameworks
end

# Targets
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
