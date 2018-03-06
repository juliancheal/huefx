require_relative 'light'
require_relative 'sensor'
require_relative 'automation'

module Huefx
  # Worker
  class Worker
    def initialize
      load_automations
      initialize_sensors
      initalize_lights
    end

    def load_automations
      huefx_automation = Huefx::Automation.new
      huefx            = huefx_automation.load_automation

      @settings    = huefx[:huefx]
      @automations = huefx[:automations]
    end

    def initalize_lights
      light_automations = @automations.map { |light| light[:action][:entity_id] }
      @lights = []
      light_automations.uniq.each do |light|
        @lights << Light.new(light)
      end
      @lights
    end

    def initialize_sensors
      @sensors = Sensor.new
    end

    def preform
      _amount = 0.3
      _min    = 0.2

      previous_states = []

      @sensors.each do |sensor|
        previous_state = { name: sensor.name, button_event: sensor.button_event, last_updated: sensor.last_updated }
        previous_states << Struct.new(*previous_state.keys).new(*previous_state.values)
      end

      loop do
        sleep @settings[:interval].to_i
        events = @sensors.refresh

        events.each do |event|
          location = event.name
          previous_state = previous_states.find { |state| state.name == location }
          current_state = events.find { |e| e.name == location }

          next unless previous_state.last_updated != current_state.last_updated.to_s
          previous_states = events
          automation_event = @automations.find { |data| data[:trigger][:event_data] == event.button_event }

          next unless event.button_event == automation_event[:trigger][:event_data]
          light = @lights.find { |l| l.id == automation_event[:action][:entity_id] }
          light.send(automation_event[:action][:service])
          puts "When #{automation_event[:trigger][:event_type]} is #{automation_event[:trigger][:event_data]}"
          puts "#{automation_event[:action][:entity_id]} is #{automation_event[:action][:service]}"
        end
      end
    end
  end
end
