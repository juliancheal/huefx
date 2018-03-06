require 'yaml'

module Huefx
  # Automation
  class Automation
    attr_reader :automations, :settings, :lights, :sensors

    DEFAULT_CONFIG    = File.expand_path('../../config/automation.config.yml', __dir__)
    AUTOMATION_CONFIG = "#{Dir.home}/.huefx-automation.yml"

    def initialize
      # automate_data = load_automation
      # @settings    = automate_data[:huefx]
      # @automations = automate_data[:automations]
      # @lights      = automate_data[:lights]
      # @sensors     = automate_data[:sensors]
    end

    def generate(default_config, automation_config)
      config     = default_config    ? default_config    : DEFAULT_CONFIG
      automation = automation_config ? automation_config : AUTOMATION_CONFIG

      huefx_config = load_automation(config)
      hue_sensor   = Huefx::HueSensor.to_automation
      lifx_light   = Huefx::LifxLight.to_automation

      automations = huefx_config.merge(hue_sensor.merge(lifx_light))
      automations.to_yaml

      File.write(automation, automations.to_yaml)
    end

    private

    def load_automation(file)
      @config_file ||= load_yml(file)
      return unless @config_file
      symbolise(@config_file)
    end

    def load_yml(file)
      yml_path = File.expand_path(file)
      return nil unless File.exist?(yml_path)
      YAML.load_file(yml_path)
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
