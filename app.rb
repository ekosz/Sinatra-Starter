# encoding: utf-8
require 'compass'
require 'sinatra'
require 'haml'

class MyApp < Sinatra::Base
  enable :sessions

  configure :production do
    set :haml, { :ugly=>true }
    set :clean_trace, true
  end

  configure :development do
    # ...
  end

  configure do
    set :views, File.dirname(__FILE__) + '/app/views'
    Compass.add_project_configuration(File.join(Sinatra::Application.root, 'config', 'compass.config'))
    set :haml, { :format => :html5 }
    set :scss, Compass.sass_engine_options
  end

  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end
end

require_relative 'app/models/init'
require_relative 'app/helpers/init'
require_relative 'app/routes/init'

#get '/' do
#  "Hello World"
#end

get '/stylesheets/:name.css' do
  content_type 'text/css', :charset => 'utf-8'
  scss "stylesheets/#{params[:name]}".to_sym
end
