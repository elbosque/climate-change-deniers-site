require 'sinatra'
require "sinatra/config_file"
require 'net/http'
require 'uri'
require 'octokit'

config_file 'config.yml'


get '/' do 
  erb :index
end


get "/create-issue" do
  client = Octokit::Client.new(:login => 'clime-hater', :password =>'waffles1234') 
  client.create_issue('elbosque/climate-change-positions', 'Climehate', 'Testhing this thing out', {:labels => 'label' })
end