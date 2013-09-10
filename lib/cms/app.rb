require 'cms'
require 'will_paginate'
require 'will_paginate/mongoid'

class Cms::App < Sinatra::Base
  enable :sessions
  set :port, 4568

  before do
    content_type :json
    headers 'Access-Control-Allow-Origin' => 'http://localhost:4567',
      'Access-Control-Allow-Headers' => 'Content-Type'
  end

  helpers do
    def current_user
      return @current_user if @current_user

      if session[:user_id]
        @current_user = User.find(session[:user_id])
      end
    end
  end

  get '/content/:type.?:format?' do
    @content = Content.where(type: params[:type].singularize)
      .paginate(page: params[:page], per_page: params[:per_page])
    @content = @content.where(medium: params[:medium]) if params[:medium]
    @content.to_json(except: :versions)
  end

  get '/content/:type/:id.?:format?' do
    @content = Content.find(params[:id])
    @content.to_json
  end

  post '/content/:type.?:format?' do
    halt 401, {error: 'You must be logged in to do that'}.to_json unless current_user
    request.body.rewind
    data = JSON.parse request.body.read
    @content = Content.create data['content'].merge(type: params[:type].singularize)
    @content.to_json
  end

  options('/content/:type') { halt 200 }

  post '/sessions/?' do
    if user = User.find_by(username: params[:username])
      if user.authenticate(params[:password])
        session[:user_id] = user.id
      else
        halt 401, {error: 'Invalid credentials provided.'}.to_json
      end
    end
  end

  run! if __FILE__ == $0
end
