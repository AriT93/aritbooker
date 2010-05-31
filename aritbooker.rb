#!/usr/env/ruby

require 'rubygems'
require 'sinatra'
require 'haml'
require 'frankie'

configure do
  set :sessions, true
  load_facebook_config "./config/facebooker.yml", Sinatra::Application.environment
end

before do
  ensure_authenticated_to_facebook
  ensure_application_is_installed_by_facebook_user
 end

get '/' do

# haml :home
  body "<h1>hello welcome to frankie</h1>"

end
