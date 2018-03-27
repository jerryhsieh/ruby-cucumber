require 'sinatra/base'

class MyApp < Sinatra::Base
  get '/' do
    erb :index
  end

  get '/form' do
    erb :form
  end

  post '/thankyou' do
    @name = params['name']
    @email = params['email']
    erb :thankyou  
  end
  
end
