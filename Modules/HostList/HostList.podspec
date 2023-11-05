# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'HostList'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'HostList',
    dependencies: %w[
        CoreDataService
        SnapKit
        SharedExtensions
        SharedProtocolsAndModels
        WakeOnLanService
        WOLResources
        WOLUIComponents
        SharedRouter
        ReachabilitySwift
        CocoaLumberjack/Swift
    ],
    submodules: %w[
        Bundle
        HostList
        Localization
    ],
    need_create_mock_spec: false,
    need_create_test_spec: false
)
