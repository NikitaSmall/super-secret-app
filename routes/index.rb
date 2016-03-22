module Sinatra
  module App
    module Routing
      module Index

        def self.registered(app)
          main_page = lambda do
            slim :index
          end

          app.get "/", &main_page
        end

      end
    end
  end
end
