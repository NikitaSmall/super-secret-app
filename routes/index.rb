module Sinatra
  module App
    module Routing
      module Index

        def self.registered(app)
          main_page = lambda do
            slim :index
          end

          repo_charts = lambda do
            slim :repos
          end

          app.get "/", &main_page
          app.get "/repos", &repo_charts
        end

      end
    end
  end
end
