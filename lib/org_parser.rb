require 'date'
require 'json'

class OrgParser
  attr_reader :mode

  ALLOWED_KEYS = ['login', 'html_url']

  def initialize(original_query, raw_orgs, mode = 'weekly', sort = :commits_count)
    @original_query = original_query
    @raw_orgs = raw_orgs

    @mode = date_in_bounds?(mode) ? mode : 'weekly'
    @sort = sort
  end

  def parse
    @result ||= parse_orgs
  end

  private
  def parse_orgs
    return cached_orgs unless cached_orgs.empty?

    result = filter_orgs
    save_orgs(result)
  end

  def cached_orgs
    @orgs ||= Org.
      where(original_query: @original_query, mode: @mode).
      sort(@sort => -1).to_a.map(&:attributes)
  end

  def save_orgs(batch)
    Org.collection.insert_many batch
    batch
  end

  def filter_orgs
    @raw_orgs.each do |raw_org|
      raw_org.select! { |key, _| ALLOWED_KEYS.include?(key) }

      collect_statistics(raw_org)
      raw_org['original_query'] = @original_query
      raw_org['mode'] = @mode
    end

    @raw_orgs.sort { |o_one, o_two| o_two[@sort.to_s] <=> o_one[@sort.to_s] }
  end

  def collect_statistics(org)
    org['total_commits_count'] = repos(org).reduce(0) do |total, repo|
      total + GitCounter.new(repo['full_name'], 'eternal').count_commits
    end

    org['average_commits_count'] = org['total_commits_count'] / (members(org).count + 1.0)
  end

  def repos(org)
    parse_request(repos_request(org['login']))
  end

  def members(org)
    parse_request(members_request(org['login']))
  end

  def repos_request(orgs_name)
    uri = URI("https://api.github.com/orgs/#{orgs_name}/repos?per_page=100&#{api_credentials}")
    Net::HTTP.get(uri)
  end

  def members_request(orgs_name)
    uri = URI("https://api.github.com/orgs/#{orgs_name}/members?per_page=100&#{api_credentials}")
    Net::HTTP.get(uri)
  end

  def parse_request(request_result)
    result = JSON.parse(request_result)
  end

  def date_in_bounds?(mode)
    left_date, _ = @original_query[8..-1].split('..')
    start_date = Date.parse(left_date)

    start_date <= criteria_start_date(mode)
  end

  def criteria_start_date(mode)
    case mode
    when 'weekly'
      7
    when 'monthly'
      30
    end.days.ago.to_date
  end

  def api_credentials
    "client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
  end
end
