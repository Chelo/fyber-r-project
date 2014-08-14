require 'sinatra'
require 'mongoid'

ENV['RACK_ENV'] ||= 'development'

Mongoid.load!("config/mongoid.yml")

get '/' do
    'Hello world!'
end
