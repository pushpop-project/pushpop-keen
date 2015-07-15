require 'pushpop'
require 'keen'

module Pushpop

  class Keen < Step

    PLUGIN_NAME = 'keen'

    Pushpop::Job.register_plugin(Keen::PLUGIN_NAME, Keen)

    attr_accessor :_event_collection
    attr_accessor :_analysis_type
    attr_accessor :_timeframe
    attr_accessor :_target_property
    attr_accessor :_group_by
    attr_accessor :_interval
    attr_accessor :_filters
    attr_accessor :_steps
    attr_accessor :_analyses
    attr_accessor :_max_age

    def run(last_response=nil, step_responses=nil)
      ret = self.configure(last_response, step_responses)

      if self._analysis_type == 'funnel'
        ::Keen.funnel(self.to_analysis_options)
      elsif !self._analysis_type.nil?
        ::Keen.send(self._analysis_type, self._event_collection, self.to_analysis_options)
      else
        ret
      end
    end

    def configure(last_response=nil, step_responses=nil)
      self.instance_exec(last_response, step_responses, &block)
    end

    def record(name, properties)
      ::Keen.publish(name, properties)
    end

    def to_analysis_options
      { timeframe: self._timeframe,
        target_property: self._target_property,
        group_by: self._group_by,
        interval: self._interval,
        filters: self._filters,
        analyses: self._analyses,
        max_age: self._max_age,
        steps: self._steps
      }.delete_if { |_, v| v.nil? }
    end

    def event_collection(event_collection)
      self._event_collection = event_collection
    end

    def analysis_type(analysis_type)
      self._analysis_type = analysis_type
    end

    def timeframe(timeframe)
      self._timeframe = timeframe
    end

    def target_property(target_property)
      self._target_property = target_property
    end

    def group_by(group_by)
      self._group_by = group_by
    end

    def interval(interval)
      self._interval = interval
    end

    def filters(filters)
      self._filters = filters
    end

    def steps(steps)
      self._steps = steps
    end

    def analyses(analyses)
      self._analyses = analyses
    end

    def max_age(max_age)
      self._max_age = max_age
    end

  end

end
