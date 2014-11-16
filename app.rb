require 'sinatra'
require "sinatra/config_file"
require 'net/http'
require 'uri'
require 'octokit'
require 'yaml'

config_file './config.yml'


get '/' do 
  erb :index
end

post '/parse-form' do
  create_issue(params)
end

private

def create_issue(options = {})
  client = Octokit::Client.new(:login => 'clime-hater', :password =>'waffles1234') 
  client.create_issue('elbosque/climate-change-positions', 'Climehate', options.to_yaml, {:labels => 'label' })
end