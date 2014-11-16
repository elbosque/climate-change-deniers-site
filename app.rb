require 'sinatra'
require "sinatra/config_file"
require 'net/http'
require 'uri'
require 'octokit'
require 'yaml'
require 'json/ext'
require 'mongo'
require 'byebug'

config_file './config.yml'

include Mongo

configure do
  conn = MongoClient.new("localhost", 27017)
  set :mongo_connection, conn
  set :mongo_db, conn.db('waffle_house')
end

get '/' do 
  erb :index
end

get '/legislator-positoins'

post '/parse-form' do
  create_issue(params)
end

private

def create_issue(options = {})
  client = Octokit::Client.new(:login => settings.github_name, :password =>settings.github_pass) 
  client.create_issue('elbosque/climate-change-positions', 'Climehate', options.to_yaml, {:labels => 'label' })
end