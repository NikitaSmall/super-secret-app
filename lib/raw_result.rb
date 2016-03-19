# this model stores raw result from the api. We can use it for future purposes
# and as a catch system.
class RawResult
  include DataMapper::Resource

  property :id,             Serial

  property :original_query, String
  property :result,         String

  # these fields will help to determinate if we already have got the results
  property :start_date,     DateTime
  property :end_date,       DateTime

  property :created_at,     DateTime
end
