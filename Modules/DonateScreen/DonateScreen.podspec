# frozen_string_literal: true

require_relative '../../ruby-utils/cocoapods/podspec_helper'

# Constants

private_module_name = 'DonateScreen'

# PodSpec

PodUtils.defmodule(
    name: private_module_name,
    summary: 'DonateScreen',
    dependencies: %w[
        SharedRouter
        WOLResources
        WOLUIComponents
        SharedProtocolsAndModels
        IAPManager
        SnapKit
        CocoaLumberjack/Swift
        SharedExtensions
    ],
    submodules: %w[
        Bundle
        DonateScreen
    ],
    need_create_mock_spec: false,
    need_create_test_spec: false
)
