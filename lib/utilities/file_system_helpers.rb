module Utilities
  module FileSystemHelpers

    def file_exists?(filename)
      return false if filename.nil? || filename.length < 1
      File.file?(filepath_from(filename))
    end

    def filepath_from(filename)
      def filepath_from(filename)
        return filename if filename.nil? || filename.length < 1

        if filename[0] == '/' || filename[0] == '~' || filename[1] == ':'
          filename
        else
          File.join(Dir.pwd, filename)
        end
      end
    end

  end
end