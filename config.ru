#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'
require 'frankie'
require 'haml'
require 'aritbooker.rb'

set :environment, :devlopment

run Sinatra::Application
