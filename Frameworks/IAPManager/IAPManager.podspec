# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'IAPManager'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'Provides set of basic services for making in-app purchases',
    dependencies: %w[
        SharedProtocolsAndModels
    ],
    submodules: %w[
        Core
        Models
    ],
    need_create_mock_spec: false,
    need_create_test_spec: false
)
