require 'log4r'
require 'configliere'

module Utilities
  module LoggingHelpers
    MAX_CLASSNAME_LEN = 12

    include Log4r

    attr_accessor :log


    def switch_logging_configuration_source(config)
      @logging_config_source = config
    end

    def logging_config
      @logging_config_source || Settings
    end

    def setup_logging(parent_logger=nil, filename_prefix='')
      logger_name = "#{(parent_logger.nil? ? '' : ''+parent_logger+'::')}#{classname(self,MAX_CLASSNAME_LEN)}"
      create_logger(logger_name, filename_prefix)
    end

    def classname(object, max_length=nil)
      name = object.class.to_s.split("(")[0].split(":").last
      name = name[0,max_length] if max_length
      name
    end

    def log_fullpath(filename_prefix='')
      (logging_config['logs.path'] || '.') + '/' + log_filename(filename_prefix)
    end

    def log_filename(prefix='')
      time = Time.new
      "#{prefix.length>0 ? prefix+'_' : ''}#{classname(self)}" + "_" +
          log_time_to_dotted_string(time) + ".log"
    end

    def log_time_to_dotted_string(time)
      "#{time.year.to_s.rjust(4,'0')}" +
          ".#{time.month.to_s.rjust(2,'0')}.#{time.day.to_s.rjust(2,'0')}" +
          ".#{time.hour.to_s.rjust(2,'0')}.#{time.min.to_s.rjust(2,'0')}" +
          ".#{time.sec.to_s.rjust(2,'0')}"
    end

    def log_level_from_string(string_level)
      string_level = string_level.to_s.upcase

      i = LNAMES.index(string_level)
      i = 0 if i.nil? # When in doubt, set to 'ALL'

      eval(LNAMES[i])
    end

    def create_logger(logger_name, filename_prefix='')
      if logging_config['logs.run_silent']
        @log = Logger.root
      else
        @log = Logger.new logger_name

        if classname(self, MAX_CLASSNAME_LEN) == logger_name
          level_for_screen = log_level_from_string(logging_config['logs.level_screen'] || 'INFO')
          level_for_file   = log_level_from_string(logging_config['logs.level_file']   || 'ALL')

          std_pattern = PatternFormatter.new(:pattern => "%-#{MAX_CLASSNAME_LEN}c | %-5l | %m")
          o = Log4r::StdoutOutputter.new('stdout', :level => level_for_screen,
                                         :formatter => std_pattern)
          @log.outputters << o

          file_pattern = PatternFormatter.new(:pattern => "%d | %-#{MAX_CLASSNAME_LEN}c | %-5l | %m")
          @log.outputters << Log4r::FileOutputter.new('file', :filename => log_fullpath(filename_prefix),
                                                      :trunc => true, :level => level_for_file,
                                                      :formatter => file_pattern)
        end
      end
    end


    # Helpers for easy logging of certain types of data

    def log_list(list, label=nil, log_method=:debug)
      label = label || "Items"

      log.send(log_method, "#{label} (#{list.length}):")
      list.each{ |item| log.send(log_method, "   * #{item}") }
    end

  end
end