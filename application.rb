require "rubygems"
require "bundler/setup"
require "sinatra"
require "sinatra/base"

require File.join(File.dirname(__FILE__), "environment")
require File.join(File.dirname(__FILE__), "routes/index")


class Githuber < Sinatra::Base
  configure do
    set :views, "#{File.dirname(__FILE__)}/views"
    set :show_exceptions, :after_handler
  end

  configure :production, :development do
    enable :logging
  end

  # error handling
  not_found do
    slim 'h1 Your path is blocked!'
  end

  # registered routes
  register Sinatra::Githuber::Routing::Index
end
