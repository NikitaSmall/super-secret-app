module Sinatra
  module App
    module Routing
      module Index

        def self.registered(app)
          main_page = lambda do
            slim :index
          end

          repos = lambda do
            client = Githuber.new(params[:period].to_sym)
            parser = RepoParser.new(
              client.query, client.repos,
              params[:criteria_period], params[:sorting]
            )

            slim :repos, locals: { sorting: params[:sorting], repos: parser.parse }
          end

          repo_chart = lambda do
            slim :repo_chart
          end

          app.get "/", &main_page
          app.get "/repos/:period/:criteria_period/:sorting", &repos
          app.get "/repo_chart", &repo_chart
        end

      end
    end
  end
end
