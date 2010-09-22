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
 e = request.env['sinatra.error']
end

helpers do
  def status_message(status)
    status.instance_variable_get(:@message)
  end
    #define helpers here
  def partial(name, options={})
    item_name = name.to_sym
    counter_name = "#{name}_counter".to_sym
    if collection = options.delete(:collection)
      collection.enum_for(:each_with_index).collect do |item, index|
        partial(name, options.merge(:locals => { item_name => item, counter_name => index + 1 }))
      end.join

    elsif object = options.delete(:object)
      partial name, options.merge(:locals => {item_name => object, counter_name => nil})
    else
      haml "_#{name}".to_sym, options.merge(:layout => false)
    end
  end
  def fb2hd
    if fb[:user]
      @email = DmUser.first(:fb_uid => fb[:user].to_s)
      @user = AbUser.first(:email => @email.email)
    end
  end
  @user
end

before do
  @user = fb2hd
  if @user == nil
    @user = AbUser.first(:email => current_user.email)
  end
  @fbs = MiniFB::OAuthSession.new(@user.atoken,"en_US")
end

get '/' do
  redirect '/login' unless logged_in?
  if !current_user.email
    current_user.destroy!
    flash[:notice] = "You need to login or create an account first then link it to your Facebook accout"
    session[:user] =nil
    redirect '/login'
  else
    @user = AbUser.first(:email => current_user.email)
    if @user == nil
      @user = AbUser.new(:email => current_user.email)
      @user.save
    end
    @oauth_url = MiniFB.oauth_url(@@yaml["app_id"],@@yaml["callback_url"] + "/sessions/create",:scope=>MiniFB.scopes.join(","))
    @fbs = MiniFB::OAuthSession.new(@user.atoken,"en_US")
    haml :index
  end
end

get '/sessions/create' do
  @access_token_hash = MiniFB.oauth_access_token(@@yaml["app_id"],@@yaml["callback_url"] + "/sessions/create",@@yaml["secret_key"], params[:code])
  @access_token = @access_token_hash["access_token"]
  env[:access_token] = @access_token
  @user = AbUser.first(:email => current_user.email)
  if @user != nil
    @user.atoken = @access_token
    @user.name = "lbah"
    @user.save
  end
  redirect "/"
end

get '/like/:id' do
  @fbs.post(params[:id],:type => "likes")
  redirect '/'
end
get '/comment/:id' do
  params[:comment] + " ; " + params[:id]
end

post '/comment/:id' do
  @fbs.post(params[:id], :type => "comments", :params =>{ :message => params[:comment]})
#  params[:comment] + " ; " + params[:id]
  redirect '/'
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
    @user = AbUser.first(:email => @email.email)
  end

  haml :fbook2, :layout => false
end
