require 'lifx-lan'

module Huefx
  # Light
  class Light
    attr_reader :id

    def initialize(id)
      @id     = id
      tm      = LIFX::LAN::TransportManager::LAN.new
      nc      = LIFX::LAN::NetworkContext.new(transport_manager: tm)
      @light  = LIFX::LAN::Light.new(context: nc, id: @id)
    end

    def turn_on
      @light.turn_on
    end

    def turn_off
      @light.turn_off
    end

    def brightness(value); end
  end
end
