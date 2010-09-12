#!/usr/env/ruby

require "rubygems"
require 'environment'
require 'sinbook'
require 'sinatra'
require 'dm-core'
require 'digest/sha1'
require 'sinatra-authentication'
require 'haml'
require 'sass'
require 'rack-flash'
require 'pp'
require 'mini_fb'
use Rack::Session::Cookie, :secret=>"supahsekrit is the bestes sekrit"
use Rack::Flash


set :sinatra_authentication_view_path, Pathname(__FILE__).dirname.expand_path + "views/"


error do
 request.env['sinatra.error']
end

helpers do
  def status_message(status)
    status.instance_variable_get(:@message)
  end
    #define helpers here
  def partial(name, options={})
    haml("_#{name.to_s}".to_sym, options.merge(:layout => false))
  end
  def fb2hd
    if fb[:user]
      @email = DmUser.first(:fb_uid => fb[:user].to_s)
      @user = HdUser.first(:email => @email.email)
    end
  end
end

before do
  @user = nil
end



get '/' do
  redirect '/login' unless logged_in?
  if !current_user.email
    current_user.destroy!
    flash[:notice] = "You need to login or create an account first then link it to your Facebook accout"
    session[:user] =nil
    redirect '/login'
  else
    @user = HdUser.first(:email => current_user.email)
    if @user == nil
      @user = HdUser.first(:email => current_user.email)
      @user.save
    end
    @oauth_url = MiniFB.ouath_url(@@yaml["app_id"],@@yaml["callback_url"] + "/sessions/create",:scope=>MiniFB.scopes.join(","))
    haml :index
  end
end

get '/sessions/create' do
  access_token_hash = MiniFB.oauth_access_token(@@yaml["app_id"],@@yaml["callback_url"] + "/sessions/create",@@yaml["secret_keyh"], params[:code])
  @access_token = access_token_hash["access_token"]
  env[:access_token] = @access_token
  @access_token
end


get '/css/style.css' do
  content_type 'text/css'
  sass :style
end

get '/login' do
  haml :login
end

get '/signup' do
  haml :signup
end

get '/logout' do
  haml "= render_login_logout"
end

get '/canvas/' do
  if fb[:user]
    @email = DmUser.first(:fb_uid => fb[:user].to_s)
    @user = HdUser.first(:email => @email.email)
  end

  haml :fbook2, :layout => false
end
