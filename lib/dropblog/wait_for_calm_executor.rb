require 'timers'

module Dropblog
  class WaitForCalmExecutor

    def initialize(executable)
      fail ArgumentError unless executable.methods.include?(:execute)
      @executable = executable
      @waiting_period = 0
      @timers = Timers::Group.new
    end

    def ask_to_execute
      if @waiting_period > 0
        if @scheduled_execution
          @scheduled_execution.cancel
        else
          @scheduled_execution ||= @timers.after(@waiting_period) do
            @executable.execute
            true
          end
        end
        @timers.wait
      elsif @waiting_period == 0
        @executable.execute
        true
      else
        false
      end
    end

    def disable_execution!
      @waiting_period = -1
    end

    def wait_seconds_for_calm!(seconds)
      @waiting_period = seconds
    end
  end
end
