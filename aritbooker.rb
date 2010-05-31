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

get '/' do
    # haml :home
#  "<h1>hello #{session[:facebook_session].user.name} welcome to frankie</h1><br/>
  a = 1
  bstr = ""
  for a_friend in session[:facebook_session].user.friends
    bsr += "<p>" +  fb_name(a_friend) +  "</p>"
  end
  bstr
end
