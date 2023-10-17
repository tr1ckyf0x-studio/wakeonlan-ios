# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'SharedRouter'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'SharedRouter',
    dependencies: %w[
        RouteComposer
    ],
    submodules: %w[
        SharedRouter
    ],
    need_create_mock_spec: false,
    need_create_test_spec: false
)
