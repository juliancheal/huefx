require 'hue'

module Huefx
  # HueSensor
  class HueSensor
    def initialize; end

    def discover
      discover
    end

    def self.discover
      @client = Hue::Client.new
    rescue Hue::LinkButtonNotPressed => e
      puts e
    end

    def self.to_automation
      hue = discover
      sensors = hue.sensors

      sensors_output = []
      sensors.each do |sensor|
        sensors_output << {
          type: sensor.type,
          name: sensor.name,
          id: sensor.id,
          model: sensor.model,
          manufacturer: sensor.manufacturer,
        }
      end

      {
        username: hue.username,
        bridges: { ip: hue.bridges.map(&:ip) },
        sensors: sensors_output,
      }
    end
  end
end
