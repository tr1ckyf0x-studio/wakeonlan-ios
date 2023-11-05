# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'AboutScreen'

# PodSpec

PodHelper.defmodule(
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
        Bundle
        Localization
    ],
    need_create_mock_spec: false,
    need_create_test_spec: false
)
