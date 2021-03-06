#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'aritbooker.rb'
require 'dm-core'
require 'sinatra-authentication'
require 'sass'
require 'aritbooker'


set :run, false
set :environment, :development
enable :logging

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a+")
$stdout.reopen(log)
$stderr.reopen(log)

run Sinatra::Application
