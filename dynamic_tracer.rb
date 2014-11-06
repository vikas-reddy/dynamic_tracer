require 'sinatra'
require './models/ws_configuration.rb'

class DynamicTracer < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    @ws_config = WsConfiguration.load('./config/web_services.yml', 'development')
    haml :index, locals: {list: @list}
  end
end
