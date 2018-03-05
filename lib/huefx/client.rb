require_relative 'hue_sensor'

module Huefx
  # HueSensor
  class Client
    attr_reader :hue_sensors, :lifx_lights

    def discover_hue
      @hue_sensors = Huefx::HueSensor.new
      @hue_sensors.discover
    rescue Hue::LinkButtonNotPressed => e
      puts e
    end

    def discover_lifx
      @lifx_lights = Huefx::LifxLight.new
      @lifx_lights.discover
    end

    def generate_automation
      automation = Huefx::Automation.new
      automation.generate
    end
  end
end
