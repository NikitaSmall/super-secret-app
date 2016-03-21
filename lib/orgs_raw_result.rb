# this model stores raw result from the api. We can use it for future purposes
# and as a catch system.
class OrgsRawResult
  include Mongoid::Document

  field :original_query, type: String
  field :result,         type: Array

  field :created_at,     type: DateTime, default: ->{ Time.now }

  index({ original_query: 1 })
end
