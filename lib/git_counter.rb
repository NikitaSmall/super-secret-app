require 'net/http'
require 'json'
require 'date'

require_relative 'github_api.rb'

class GitCounter
  include GithubApi

  def initialize(repo_name, mode)
    @repo_name = repo_name
    @date = select_date(mode)

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
    return [] unless commits.is_a? Array

    @commits_bunch ||= commits.select do |commit|
      Date.parse(commit['commit']['author']['date']) > @date
    end
  end

  def stars
    # return @stars unless @stars.empty?

    # loop do
    #   temp_stars = parse_response(star_request)

    #   @stars += temp_stars
    #   @star_page += 1
    #   break if temp_stars.count < 100
    # end

    @stars ||= parse_response(star_request)
  end

  def commits
    # return @commits unless @commits.empty?

    # loop do
    #   temp_commits = parse_response(commit_request)
    #
    #   @commits += temp_commits
    #   @commit_page += 1
    #   break if temp_commits.count < 100
    # end

    @commits ||= parse_response(commit_request)
  end

  def select_date(mode)
    case mode
    when 'weekly'
      7.days.ago
    when 'monthly'
      30.days.ago
    when 'eternal'
      9000.days.ago
    end
  end
end
