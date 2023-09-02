# frozen_string_literal: true

class GlobalConfiguration
    # Prefix to the root of the project
    @@root_prefix_path = '.'

    def self.root_prefix_path
        @@root_prefix_path
    end
end

def feature_module(name:, need_create_testspecs: true)
    pod name, path: "#{GlobalConfiguration.root_prefix_path}/Modules/#{name}", testspecs: need_create_testspecs ? ['Tests'] : []
end

def framework_module(name:, need_create_testspecs: true)
    pod name, path: "#{GlobalConfiguration.root_prefix_path}/Frameworks/#{name}", testspecs: need_create_testspecs ? ['Tests'] : []
end

def external_framework_git(name:, source:, version:)
    pod name, git: source, tag: version
end

def external_framework(name:, version:)
    pod name, version
end
