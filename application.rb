require "rubygems"
require "bundler/setup"
require "sinatra"
require "sinatra/base"

require File.join(File.dirname(__FILE__), "environment")
require File.join(File.dirname(__FILE__), "routes/index")


class App < Sinatra::Base
  configure do
    set :views, "#{File.dirname(__FILE__)}/views"
    set :show_exceptions, :after_handler
  end

  configure :production, :development do
    enable :logging
  end

  helpers do
    def check_number(number)
      number == 100 ? 'more than one hundred!' : "#{number}"
    end

    def normal_form(mode)
      case mode
      when 'weekly'
        'week'
      when 'monthly'
        'month'
      end
    end
  end

  # error handling
  not_found do
    slim 'h1 Your path is blocked!'
  end

  # registered routes
  register Sinatra::App::Routing::Index
end
