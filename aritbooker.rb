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
#  ensure_application_is_installed_by_facebook_user
 end

post '/' do
    # haml :home
  get_users_as_fbml
end

get '/' do
  get_users_as_fbml
end

def get_users_as_fbml
  bstr = ""
  for a_friend in session[:facebook_session].user.friends
    bstr += "<p><fb:name uid='#{Facebooker::User.cast_to_facebook_id a_friend}'></fb:name></p>"
  end
  bstr
end
