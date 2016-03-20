# this model stores parsed data from github api
class Repo
  include Mongoid::Document

  field :full_name, type: String
  field :original_query, type: String
  field :mode, type: String

  field :html_url,  type: String
  field :description, type: String

  field :stargazers_count, type: Integer
  field :commits_count, type: Integer
  field :contributors_count, type: Integer

  index({ full_name: 1 })
  index({ original_query: 1, mode: 1 })

  index({ stargazers_count: 1 })
  index({ commits_count: 1 })
  index({ contributors_count: 1 })
end
