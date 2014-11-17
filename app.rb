require 'sinatra'
require "sinatra/config_file"
require "sinatra/assetpack"
require 'net/http'
require 'uri'
require 'octokit'
require 'yaml'
require 'json/ext'
require 'mongo'
require 'byebug'

assets do
  serve '/js', from: 'js'
  serve '/bower_components', from: 'bower_components'

  js :modernizr, [
    '/bower_components/modernizr/modernizr.js',
  ]

  js :libs, [
    '/bower_components/jquery/dist/jquery.js',
    '/bower_components/foundation/js/foundation.js'
  ]

  js :application, [
    '/js/app.js', '/js/helloworld.js'
  ]

  js_compression :jsmin
end

include Mongo

configure do
  conn = MongoClient.new("localhost", 27017)
  set :mongo_connection, conn
  set :mongo_db, conn.db('waffle_house')
end

get '/' do
  @legislator_positions = settings.mongo_db['climate_change_positions'].find
  erb :index
end

#get '/legislator-positions' do
#  return settings.mongo_db['climate_change_positions'].find
#end

post '/parse-form' do
  create_issue(params)
end

private

def get_file(bioguide)

end

def create_issue(options = {})
  client = Octokit::Client.new(:login => ENV['GITHUB_NAME'], :password => ENV['GITHUB_PASS']) 
  client.create_issue('elbosque/climate-change-positions', options["bioguide"], options.to_yaml, {:labels => 'label' })
end