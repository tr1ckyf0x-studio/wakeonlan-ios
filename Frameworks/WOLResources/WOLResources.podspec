# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'WOLResources'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'Resources module',
    dependencies: %w[
    ],
    submodules: %w[
        Bundle
        WOLResources
    ],
    need_create_mock_spec: false,
    need_create_test_spec: false
)
