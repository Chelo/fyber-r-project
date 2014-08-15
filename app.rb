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
helpers Utils

get '/packages' do
  @packages = Package.all
  haml :index
end

get '/packages/:id' do
  @package = Package.where(id: params[:id]).first
  if @package
    @package_vs = @package.package_versions if @package
    haml :show
  else
    @message = "Invalid package id"
    @packages = Package.all
    haml :index
  end
end
