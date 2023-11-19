# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'SharedProtocolsAndModels'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'SharedProtocolsAndModels',
    dependencies: %w[
    ],
    submodules: %w[
        SharedProtocolsAndModels
    ],
    need_create_mock_spec: false,
    need_create_test_spec: false
)
