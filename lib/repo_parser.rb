class RepoParser

  ALLOWED_KEYS = ['full_name', 'html_url', 'description']

  def initialize(original_query, raw_repos, mode = 'weekly')
    @original_query = original_query
    @raw_repos = raw_repos

    @mode = mode
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
    @repos ||= Repo.where(original_query: @original_query, mode: @mode).to_a.map(&:attributes)
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
  end

  def collect_statistics(repo)
    counter = GitCounter.new(repo['full_name'], @mode)

    repo['stargazers_count'] = counter.count_stargazers
    repo['contributors_count'] = counter.count_contributors
    repo['commits_count'] = counter.count_commits
  end
end
