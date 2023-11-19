# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'CoreDataService'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'CoreDataService',
    dependencies: %w[
        SharedProtocolsAndModels
        CocoaLumberjack/Swift
    ],
    submodules: %w[
        Bundle
        CoreDataService
    ],
    need_create_mock_spec: false,
    need_create_test_spec: false
)
