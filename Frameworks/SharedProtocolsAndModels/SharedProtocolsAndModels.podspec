# frozen_string_literal: true

require_relative '../../ruby-utils/cocoapods/podspec_helper'

# Constants

private_module_name = 'SharedProtocolsAndModels'

# PodSpec

PodUtils.defmodule(
    name: private_module_name,
    summary: 'SharedProtocolsAndModels',
    dependencies: %w[
        WOLResources
    ],
    submodules: %w[
        SharedProtocolsAndModels
    ],
    need_create_mock_spec: false,
    need_create_test_spec: false
)
