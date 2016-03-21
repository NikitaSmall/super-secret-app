require 'net/http'
require 'json'
require 'date'

class GitCounter
  def initialize(repo_name, mode)
    @repo_name = repo_name
    @date = (mode == 'weekly') ? 7.days.ago : 30.days.ago

    # @stars = []
    # @commits = []

    @star_page = 1
    @commit_page = 1
  end

  def count_stargazers
    stars.select { |star| Date.parse(star['starred_at']) > @date }.count
  end

  def count_contributors
    commits_bunch.uniq { |commit| commit['commit']['author']['email'] }.count
  end

  def count_commits
    commits_bunch.count
  end

  private
  def commits_bunch
    @commits_bunch ||= commits.select do |commit|
      Date.parse(commit['commit']['author']['date']) > @date
    end
  end

  def stars
    # return @stars unless @stars.empty?

    # loop do
    #   temp_stars = parse(star_request)

    #   @stars += temp_stars
    #   @star_page += 1
    #   break if temp_stars.count < 100
    # end

    @stars ||= parse(star_request)
  end

  def commits
    # return @commits unless @commits.empty?

    # loop do
    #   temp_commits = parse(commit_request)
    #
    #   @commits += temp_commits
    #   @commit_page += 1
    #   break if temp_commits.count < 100
    # end

    @commits ||= parse(commit_request)
  end

  def parse(response)
    JSON.parse response
  end

  def star_request
    uri = URI("https://api.github.com/repos/#{@repo_name}/stargazers?page=#{@star_page}&per_page=100&#{api_credentials}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)
    # we need to provide these headers to get starring's date
    request.initialize_http_header({
      "Accept" => "application/vnd.github.v3.star+json",
      "User-Agent" => "super-secret-app"
    })
    response = http.request(request)

    response.body
  end

  def commit_request
    uri = URI("https://api.github.com/repos/#{@repo_name}/commits?page=#{@commit_page}per_page=100&#{api_credentials}")
    Net::HTTP.get(uri)
  end

  def api_credentials
    "client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
  end
end
