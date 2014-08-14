#!/usr/bin/env ruby

require 'mongoid'
require 'sinatra'
$: << File.join(File.dirname(File.realpath(__FILE__)), 'lib')
$ROOT = File.dirname(File.realpath(__FILE__))
require 'models'

ENV['RACK_ENV'] ||= 'development'

Mongoid.load!("config/mongoid.yml")

get '/' do
  "Hello Word"
end
