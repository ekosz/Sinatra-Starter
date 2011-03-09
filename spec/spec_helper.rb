ENV['RACK_ENV'] = 'test'

# Load the Sinatra app
require_relative '../app.rb'

require 'rspec'
require 'rack/test'

module RSpecMixinExample
  include Rack::Test::Methods
  def app() @app ||= MyApp end
end

RSpec.configure do |conf|
  conf.include RSpecMixinExample
end
