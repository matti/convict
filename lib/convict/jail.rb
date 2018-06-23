module Convict; class Jail
  attr_reader :guard

  def initialize(_path)
    @guard = false
    @path = _path
  end

  def debug(str)
    return unless ENV["CONVICT_DEBUG"]
    puts str
  end

  def run
    tp = TracePoint.new do |tp|
      debug "  #{@guard} - #{tp.self} - #{tp.defined_class} - #{tp.callee_id} - #{tp.event} - #{tp.method_id}"

      if @guard
        case tp.event
        when :c_call
          case tp.method_id
          when :method_missing
          when :set_encoding
            raise "not IO" unless tp.defined_class == IO
          when :require, :load
            raise "not Kernel" unless tp.defined_class == Kernel
          when :new
          when :initialize
          when :inherited
          when :method_added
          when :singleton_method_added
          when :puts
            debug ">> GUARD OFF"
            @guard = false
          else
            if tp.self.is_a? Exception
              raise tp.self
            else
              raise Convict::Violation, "#{tp.defined_class}.#{tp.method_id}"
            end
          end
        end
      else
        case tp.event
        when :c_call
          case tp.method_id
          when :instance_eval
            debug "  >> CELL LOCKED"
            @guard = true
          end
        when :c_return
          if tp.method_id == :puts
            debug "  >> GUARD ON"
            @guard = true
          end
        end
      end
    end

    contents = File.read @path

    begin
      Convict::Cell.new contents, @path, tp
    rescue Convict::Violation => ex
      puts ""
      puts "VIOLATION: #{ex}"
      exit 1
    rescue => ex
      puts ""
      puts "EXCEPTION:"
      puts ex.message.split("for #<Convict")[0]
      puts "in #{ex.backtrace_locations[1].to_s.split(":in `block").first}"
    else
      #puts "cell value: #{$value}"
    end
  end

end; end
