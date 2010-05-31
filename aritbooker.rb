#!/usr/env/ruby

require 'rubygems'
require 'sinatra'
require 'haml'
require 'frankie'
require 'facebooker'




configure do
  set :sessions, true
  load_facebook_config "./config/facebooker.yml", Sinatra::Application.environment
end

before do
  ensure_authenticated_to_facebook
  @fbuser = session[:facebook_session].user
#  ensure_application_is_installed_by_facebook_user
 end

post '/' do
    # haml :home
  bstr = ""
  for a_friend in session[:facebook_session].user.friends
    bstr += "<p><fb:name uid='#{Facebooker::User.cast_to_facebook_id a_friend}'></fb:name></p>"
  end
  bstr
end

get '/' do
  bstr = ""
  for a_friend in session[:facebook_session].user.friends
#    bstr += "<p><fb:name uid='#{Facebooker::User.cast_to_facebook_id a_friend}'></fb:name></p>"
    bstr += "<p>#{a_friend.name}</p>"
  end
  bstr
end

get '/status' do
  bstr = ""
  for status in @fbuser.statuses
    bstr = "<p>#{status.uid} said #{status.message}</p>"
  end
end
