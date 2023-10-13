# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'AddHost'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'AddHost',
    dependencies: %w[
        CoreDataService
        SnapKit
        SharedExtensions
        SharedProtocolsAndModels
        WOLResources
        WOLUIComponents
        CocoaLumberjack/Swift
        SharedRouter
    ],
    submodules: %w[
        AddHost
    ],
    need_create_mock_spec: false,
    need_create_test_spec: false
)
