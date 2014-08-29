require 'log4r'

###################################
# There's gotta' be a better way! #
###################################

ERR_CLASSES_TO_MOD = [RuntimeError, RangeError, TypeError, ZeroDivisionError]

# Add hook into all possible error classes
class Exception
  alias real_init initialize
end

def add_logging_for_error_class(error_class)
  return unless error_class.ancestors.include?(Exception)

  error_class.class_eval do


    def initialize(*args)
      real_init *args

      if Log4r::Logger
        # Put the backtrace into a multi-line message
        backtrace = caller.join("\n    ")
        msg = "#{self.class}: #{self.message}\n\n" +
            "Backtrace:\n    #{backtrace}"

        # Log the message to any logger chain, but only at the topmost level
        (Log4r::Logger).each_logger do |l|
          l.fatal msg if l.parent === (Log4r::Logger).root
        end
      end
    end


  end
end


ERR_CLASSES_TO_MOD.each { |klass| add_logging_for_error_class(klass) }