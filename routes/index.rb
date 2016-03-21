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

            slim :repos, locals: {
              search_period: params[:period],
              criteria_period: params[:criteria_period],
              sorting: params[:sorting],
              repos: parser.parse,
            }
          end

          repo_chart = lambda do
            start_date = params[:mode] == 'weekly' ? 7.days.ago.to_s : 30.days.ago.to_s
            parser = DetailParser.new(params[:repo_name], start_date, Time.now.to_s)

            slim :repo_chart, locals: {
              repo_name: params[:repo_name],
              mode: params[:mode],
              stars: parser.stargazers_statistics,
              commits: parser.commits_statistics,
              contributors: parser.contributors_statistics
            }
          end

          app.get "/", &main_page
          
          app.post "/repos", &repos
          app.get "/repo_charts/:mode", &repo_chart
        end

      end
    end
  end
end
