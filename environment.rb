require 'rubygems'
require 'bundler/setup'
require 'dotenv'
require 'mongoid'
require 'ostruct'

require 'slim'
require 'sinatra' unless defined?(Sinatra)

Dotenv.load

configure do
  SiteConfig = OpenStruct.new(
      :title => 'githuber',
      :author => 'Some jr.',
      :url_base => 'http://localhost:4567/'
  )

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/lib")
  Dir.glob("#{File.dirname(__FILE__)}/lib/*.rb") { |lib| require File.basename(lib, '.*') }

  Mongoid.load!(File.join(File.dirname(__FILE__), "db/mongoid.yml"), :development)
end
