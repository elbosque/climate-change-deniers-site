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
  create_pull_request(params)
end

private

def get_file(bioguide)

end

def create_pull_request(options = {})
  client = Octokit::Client.new(:login => ENV['GITHUB_NAME'], :password => ENV['GITHUB_PASS']) 
  #client.create_issue('elbosque/climate-change-positions', options["bioguide"], options.to_yaml, {:labels => 'label' })
  yaml_blob_hash = `git hash-object #{ENV['CCD_DATA_DIRECTORY']}/climate-change-positions/politicians/#{options["bioguide"]}.yml`
  yaml_blob = client.blob("clime-hater/scratch", yaml_blob_hash.strip())
  current_leg_hash = YAML.load(Base64.decode64(yaml_blob[:content]))
  return false unless has_all_options?(options)
  new_leg_hash = resolve_yaml_disputes(current_leg_hash, options)
end

def has_all_options?(options)
  options.keys.sort == ["proof", "statement_date", "bioguide", "exist", "anthropogenic", "evasive"].sort
end

def resolve_yaml_disputes(current_leg_hash, options)
  if current_leg_hash["statements"].map{|s|s["proof"]}.include?(options["statement"])
    #statement's already in there. deal with this.
  else
    current_leg_hash["statements"].push({ 
      "climate_change_stances" => {
        "anthropogenic"=> options["anthropogenic"],
        "exists"=> options["exist"]
      }, 
      "date" => options["statement_date"],
      "excerpt" => options["excerpt"],
      "proof" => options["proof"],
      "evasive" => options["evasive"]
    })
  end
  current_leg_hash
end
