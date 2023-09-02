# frozen_string_literal: true

require_relative '../../ruby-utils/cocoapods/podspec_helper'

# Constants

private_module_name = 'AboutScreen'

# PodSpec

PodUtils.defmodule(
    name: private_module_name,
    summary: 'AboutScreen',
    dependencies: %w[
        SharedExtensions
        SharedProtocolsAndModels
        SnapKit
        WOLUIComponents
        WOLResources
        SharedRouter
    ],
    submodules: %w[
        AboutScreen
    ],
    need_create_mock_spec: false,
    need_create_test_spec: false
)
