module Sinatra
  module App
    module Routing
      module Org

        def self.registered(app)
          orgs = lambda do
            client = Githuber.new(params[:period].to_sym)
            parser = OrgParser.new(
              client.query, client.orgs,
              params[:criteria_period], params[:sorting]
            )

            slim :orgs, locals: {
              search_period: params[:period],
              criteria_period: params[:criteria_period],
              sorting: params[:sorting],
              orgs: parser.parse,
            }
          end

          app.post "/orgs", &orgs
        end

      end
    end
  end
end
