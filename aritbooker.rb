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
  bstr = ""
  for a_friend in session[:facebook_session].user.friends
    uid = Facebooker::User.cast_to_facebook_id a_friend
    bstr += "<p><fb:name uid='#{uid}'></fb:name> <fb:user-status uid='#{uid}'linked='true'/> </p>"
  end
  bstr
end

get '/' do
  begin
    bstr = ""
    friends =  session[:facebook_session].user.friends!(:name, :status)
    friends.each do |a_friend|
 #     for field in Facebooker::User::FIELDS.map(&:to_s).sort
#        bstr += "#{a_friend.send(status).to_s}<br/>"
  #    end
      status = a_friend.status.message
      puts status
      bstr += "<p>#{a_friend.name} says #{status.instance_variable_get(:@message)} </p>"
    end
    bstr
  rescue
    create_new_facebook_session_and_redirect!
  end
end

get '/status' do
  "<p>#{session[:facebook_session].user.status.message}</p>"
end

post '/status' do
  "#{session[:facebook_session].user.status.message}"
end
