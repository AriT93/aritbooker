require 'spec/rake/spectask'
require 'rubygems'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'digest/sha1'
require 'dm-migrations'
require 'haml'
require 'ostruct'
require 'sinbook'
require 'sinatra' unless defined?(Sinatra)
require 'environment.rb'
require 'sinatra-authentication'
require 'aritbooker.rb'


task :default => :test
task :test => :spec

if !defined?(Spec)
  puts "spec targets require RSpec"
else
  desc "Run all examples"
  Spec::Rake::SpecTask.new('spec') do |t|
    t.spec_files = FileList['spec/**/*.rb']
    t.spec_opts = ['-cfs']
  end
end

namespace :db do
  desc 'Auto-migrate the database (destroys data)'
  task :migrate => :environment do
    DataMapper.auto_migrate!
  end

  desc 'Auto-upgrade the database (preserves data)'
  task :upgrade => :environment do
    DataMapper.auto_upgrade!
  end
end

namespace :gems do
  desc 'Install required gems'
  task :install do
    required_gems = %w{ sinatra rspec rack-test dm-core dm-validations
                        dm-aggregates haml }
    required_gems.each { |required_gem| system "sudo gem install #{required_gem}" }
  end
end

task :environment do
  require 'aritbooker'
  require 'sinatra-authentication'
  require 'sinbook'
  require 'sinatra'
  require 'mpatch'
  require 'environment'
end
