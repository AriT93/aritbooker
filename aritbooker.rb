#!/usr/env/ruby

require 'rubygems'
require 'sinatra'
require 'frankie'

configure do
  set :sessions, true
  set :environment, :development
  load_facebook_config "./config/facebooker.yml", Sinatra::Application.environment
end

before do
  ensure_authenticated_to_facebook
  ensure_application_is_installed_by_facebook_user
 end

get '/' do
body  "<h1>hello #{session[:facebook_session].user.name} and welcome to frankie</h1>"
end
