require 'yaml'

module Huefx
  # Automation
  class Automation
    attr_reader :automations, :settings, :lights, :sensors

    def initialize
      automate_data = load_automation(File.expand_path('../../huefx-automation.yml', __dir__))
      @settings    = automate_data[:huefx]
      @automations = automate_data[:automations]
      @lights      = automate_data[:lights]
      @sensors     = automate_data[:sensors]
    end

    def generate
      huefx_config = load_automation(File.expand_path('../../automation.config.yml', __dir__))
      hue_sensor   = Huefx::HueSensor.to_automation
      lifx_light   = Huefx::LifxLight.to_automation

      automations = huefx_config.merge(hue_sensor.merge(lifx_light))
      automations.to_yaml
    end

    def load_automation(file = "#{Dir.home}/.huefx-automation.yml")
      config_file = YAML.load_file(file)
      return unless config_file
      symbolise(config_file)
    end

    # code from https://gist.github.com/Integralist/9503099
    def symbolise(obj)
      if obj.is_a? Hash
        return obj.inject({}) do |hash, (k, v)|
          hash.tap { |h| h[k.to_sym] = symbolise(v) }
        end
      elsif obj.is_a? Array
        return obj.map { |hash| symbolise(hash) }
      end
      obj
    end
  end
end
