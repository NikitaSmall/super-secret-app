class Commit
  include Mongoid::Document

  field :repo_name,      type: String
  field :start_date,     type: DateTime
  field :end_date,       type: DateTime

  field :result,         type: Hash

  field :created_at,     type: DateTime, default: ->{ Time.now }

  index({ repo_name: 1, star_date: 1, end_date: 1 })
end
