#!/usr/bin/env ruby

require 'sinatra'
require 'mongoid'
require_relative "config/config"
$: << File.join(File.dirname(File.realpath(__FILE__)), 'lib')
$ROOT = File.dirname(File.realpath(__FILE__))
require 'models'
require 'services'
require 'libs'
require 'helpers'


ENV['RACK_ENV'] ||= 'development'

#load mongoid
Mongoid.load!("config/mongoid.yml")

#change the stringMax constant on open-uri to get always Tempfiles
#more info: http://adayinthepit.com/2011/06/03/ruby-openuri-open-returns-stringio-fileio/
OpenURI::Buffer.send :remove_const, 'StringMax' if OpenURI::Buffer.const_defined?('StringMax')
OpenURI::Buffer.const_set 'StringMax', 0

get '/' do
  "Hello Word"
end
