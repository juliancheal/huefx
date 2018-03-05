require 'lifx-lan'

module Huefx
  # LifxLight
  class LifxLight
    def initialize; end

    def discover
      discover # shouldn't this call self?
    end

    def self.discover
      lifx = LIFX::LAN::Client.lan
      lifx.discover!
    end

    def create_light(id)
      tm     = LIFX::LAN::TransportManager::LAN.new
      nc     = LIFX::LAN::NetworkContext.new(transport_manager: tm)
      LIFX::LAN::Light.new(context: nc, id: id)
    end

    def self.to_automation
      lifx = discover
      lights = lifx.lights

      lights_output = []
      lights.each do |light|
        lights_output << {
          name: light.label,
          id:   light.id,
        }
      end

      { lights: lights_output }
    end
  end
end
