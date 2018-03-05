
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'huefx/version'

Gem::Specification.new do |spec|
  spec.name          = 'huefx'
  spec.version       = Huefx::VERSION
  spec.authors       = ['Julian Cheal']
  spec.email         = ['julian.cheal@gmail.com']

  spec.summary       = 'Hue <3 Lifx'
  spec.description   = 'Hue Buttons and Sensors controlling Lifx Bulbs'
  spec.homepage      = 'https://github.com/juliancheal/huefx'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16.a'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
