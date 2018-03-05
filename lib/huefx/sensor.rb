require 'hue'

module Huefx
  # Sensor
  class Sensor
    attr_reader :sensors

    def initialize
      @client = Hue::Client.new
      @sensors = @client.sensors
    end

    def refresh
      @sensors = @client.sensors
    end

    def each(&block)
      @sensors.each(&block)
    end
  end
end
