# this model stores parsed data from github api
class Org
  include Mongoid::Document

  field :login, type: String
  field :original_query, type: String
  field :mode, type: String

  field :html_url,  type: String

  field :total_commits_count, type: Integer
  field :average_commits_count, type: Integer

  index({ login: 1 })
  index({ original_query: 1, mode: 1 })

  index({ total_commits_count: 1 })
  index({ average_commits_count: 1 })
end
