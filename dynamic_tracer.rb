require 'sinatra'
require 'yaml'
require 'json'
require './models/soa_configuration.rb'

class DynamicTracer < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    @ws_config = SoaConfiguration.build('config/web_services2.yml')
    haml :index
  end

  get '/fetch-trace' do
    begin
      uri = URI(params['url'])
      resp = Net::HTTP.get(uri)
      h = JSON.parse(resp)
      JSON.pretty_generate(h)
    rescue => e
      e.message
    end
  end
end
