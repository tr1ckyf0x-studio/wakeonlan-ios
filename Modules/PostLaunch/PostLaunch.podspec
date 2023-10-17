# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'PostLaunch'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'PostLaunch',
    dependencies: %w[
        AddHost
        SnapKit
        CoreDataService
        SharedRouter
        WOLResources
    ],
    submodules: %w[
        PostLaunch
    ],
    need_create_mock_spec: false,
    need_create_test_spec: false
)