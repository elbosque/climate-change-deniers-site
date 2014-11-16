require 'sinatra'
require "sinatra/config_file"
require 'net/http'
require 'uri'
require 'octokit'
require 'json/ext'
require 'mongo'

config_file 'config.yml'

include Mongo

configure do
  conn = MongoClient.new("localhost", 27017)
  set :mongo_connection, conn
  set :mongo_db, conn.db('climate_change_positions')
end

get '/' do 
  erb :index
end


get "/create-issue" do
  client = Octokit::Client.new(:login => 'clime-hater', :password =>'waffles1234') 
  client.create_issue('elbosque/climate-change-positions', 'Climehate', 'Testhing this thing out', {:labels => 'label' })
end