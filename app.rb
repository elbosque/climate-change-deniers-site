require 'sinatra'
require 'net/http'
require 'uri'

get '/' do 
  erb :index
end

get '/callback' do
  
  res = Net::HTTP.post_form URI('https://github.com/login/oauth/access_token'), { "client_id" => "aca900b2e5f04bd96f00", "client_secret" => "115bd0f23baa54b3ff57906d0184a74889931125", "code" => params['code']}

  access_token = /access_token=\S*[&]/.match(res.body)[0].split('=')[1]
  p access_token
  Net::HTTP.get URI("https://api.github.com/v3/orgs/elbosque/issues")
end

get '/response' do
end

get "/test" do
  # test = Net::HTTP.post_form URI('https://api.github.com/repos/elbosque/climate-change-positions/issues'),
                    # { "title" => "TEST TEST", "body" => "Ham Sandwich" }
  test = Net::HTTP.get URI('https://api.github.com/user/repos')
  p test
  redirect to('/')
end