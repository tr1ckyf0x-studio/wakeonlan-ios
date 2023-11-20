# frozen_string_literal: true

require 'PodHelper/podspec_helper'

# Constants

private_module_name = 'SharedExtensions'

# PodSpec

PodHelper.defmodule(
    name: private_module_name,
    summary: 'Common extensions',
    submodules: %w[
        CoreGraphics
        Foundation
        UIKit
    ]
)
