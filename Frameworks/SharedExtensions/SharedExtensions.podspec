# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'SharedExtensions'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'SharedExtensions',
    dependencies: %w[
        WOLResources
    ],
    submodules: %w[
        SharedExtensions
    ],
    need_create_mock_spec: false,
    need_create_test_spec: false
)
