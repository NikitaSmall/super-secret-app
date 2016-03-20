require 'date'

class RepoParser
  attr_reader :mode

  ALLOWED_KEYS = ['full_name', 'html_url', 'description']

  def initialize(original_query, raw_repos, mode = 'weekly', sort = :stargazers_count)
    @original_query = original_query
    @raw_repos = raw_repos

    @mode = date_in_bounds?(mode) ? mode : 'weekly'
    @sort = sort
  end

  def parse
    @result ||= parse_repos
  end

  private
  def parse_repos
    return cached_repos unless cached_repos.empty?

    result = filter_repos
    save_repos(result)
  end

  def cached_repos
    @repos ||= Repo.
      where(original_query: @original_query, mode: @mode).
      sort(@sort => -1).to_a.map(&:attributes)
  end

  def save_repos(batch)
    Repo.collection.insert_many batch
    batch
  end

  def filter_repos
    @raw_repos.each do |raw_repo|
      raw_repo.select! { |key, _| ALLOWED_KEYS.include?(key) }

      collect_statistics(raw_repo)
      raw_repo['original_query'] = @original_query
      raw_repo['mode'] = @mode
    end

    @raw_repos.sort { |r_one, r_two| r_two[@sort.to_s] <=> r_one[@sort.to_s] }
  end

  def collect_statistics(repo)
    counter = GitCounter.new(repo['full_name'], @mode)

    repo['stargazers_count'] = counter.count_stargazers
    repo['contributors_count'] = counter.count_contributors
    repo['commits_count'] = counter.count_commits
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
end
