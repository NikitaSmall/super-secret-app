require 'github_api'

class Githuber
  attr_reader :mode

  def initialize(mode = :weekly)
    @mode = mode
    @client = Github.new
  end

  def result
    @result ||= get_data.to_h
  end

  private
  def get_data
    @client.search.repos(q: 'hello').body
  end
end
