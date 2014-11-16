require 'sinatra'
require 'net/http'
require 'uri'
require 'octokit'
get '/' do 
  erb :index
end


get "/create-issue" do
  client = Octokit::Client.new(:login => 'clime-hater', :password =>'waffles1234') 
  client.create_issue('elbosque/climate-change-positions', 'Climehate', 'Testhing this thing out', {:labels => 'label' })
end