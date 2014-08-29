require 'yaml'

require 'utilities/file_system_helpers'

module Utilities
  module YamlHelpers
    include FileSystemHelpers

    def YAML_load_if_exists(filename, default_return)
      if file_exists?(filename)
        YAML::load(File.open(filepath_from(filename)))
      else
        default_return
      end
    end

    def YAML_simple_dump(filename, simple_object)
      File.open(filepath_from(filename), "w+") {|f| f << YAML::dump(simple_object)}
    end

  end
end