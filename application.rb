#!/usr/bin/env ruby
%w(rubygems oa-oauth dm-core dm-sqlite-adapter dm-migrations sinatra erb).each { |dependency| require dependency }

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/database.db")

class User
  include DataMapper::Resource
  property :id,         Serial
  property :uid,        String
  property :name,       String
  property :nickname,   String
  property :created_at, DateTime
end

DataMapper.finalize
DataMapper.auto_upgrade!

use OmniAuth::Strategies::Tsina, '403062089', '60658060559448f13b3e96801b7f9926'

enable :sessions

helpers do
  def current_user
    @current_user ||= User.get(session[:user_id]) if session[:user_id]
  end
end

get '/' do
  if current_user
    redirect "/room_list"
  else
    '<a href="/sign_in">sign in with sina weibo</a>'
  end
end

get '/auth/:name/callback' do
  auth = request.env["omniauth.auth"]
  user = User.first_or_create({ :uid => auth["uid"]}, {
      :uid => auth["uid"],
      :nickname => auth["user_info"]["nickname"],
      :name => auth["user_info"]["name"],
      :created_at => Time.now })
  session[:user_id] = user.id
  redirect '/room_list'
end


get '/sign_in' do
  redirect '/auth/tsina'
end


get '/sign_out' do
  session[:user_id] = nil
  redirect '/'
end

get "/room_list" do
  erb :room_list
end


get "/:room" do
  @room = params[:room]
  erb :room
end