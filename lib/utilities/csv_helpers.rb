require 'csv'

require 'utilities/file_system_helpers'

module Utilities
  module CsvHelpers
    include FileSystemHelpers

    def CSV_load_if_exists(filename, object_type)
      if file_exists?(filename)
        csv = CSV.read(filepath_from(filename), {:headers => true, :encoding => "UTF-8"})
        csv.map do |u|
          eval("#{object_type}").new( *([*u].map{ |e| e[1] }) )
        end
      else
        []
      end
    end

    def CSV_load_single_column(filename, column_name)
      return_array = []

      if file_exists?(filename)
        csv = CSV.read(filepath_from(filename), {:headers => true, :encoding => "UTF-8"})

        if (not csv.headers.nil?) && csv.headers.is_a?(Array)
          i = csv.headers.index(column_name)

          csv.map do |row|
            #eval("#{object_type}").new( *([*u].map{ |e| e[1] }) )
            row[i]
          end
        end
      end
    end

    def CSV_simple_dump(filename, object_array=[])
      return if object_array.nil? || object_array.empty?

      can_do = object_array[0].class.respond_to?(:members) && object_array[0].respond_to?(:to_a)
      raise 'This object cannot use CSV_simple_dump' if not can_do

      CSV.open(filepath_from(filename), "w", {:encoding => "UTF-8"}) do |csv|
        csv << object_array[0].class.members.to_a
        object_array.each do |obj|
          csv << obj.to_a
        end
      end
    end

  end
end