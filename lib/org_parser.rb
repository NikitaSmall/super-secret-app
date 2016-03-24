require 'date'
require 'json'

class OrgParser
  attr_reader :mode

  include GithubApi
  include ParserHelper

  ALLOWED_KEYS = ['login', 'html_url']

  def initialize(original_query, raw_orgs, mode = 'weekly', sort = :total_commits_count)
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
    parse_response(orgs_repos_request(org['login']))
  end

  def members(org)
    parse_response(members_request(org['login']))
  end
end
