#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'aritbooker.rb'

set :environment, :production

run Sinatra::Application
