require 'net/http'
require 'json'

class RepoParser

  ALLOWED_KEYS = [
    'full_name', 'html_url', 'description', 'stargazers_count'
  ]

  def initialize(original_query, raw_repos)
    @original_query = original_query
    @raw_repos = raw_repos
  end

  def parse
    @result ||= parse_repos
  end

  private
  def parse_repos
    return repos unless repos.empty?

    result = filter_repos
    save_repos(result)
  end

  def repos
    @repos ||= cached_repos
  end

  def cached_repos
    Repo.where(original_query: @original_query).to_a.map(&:attributes)
  end

  def save_repos(batch)
    Repo.collection.insert_many batch
    batch
  end

  def filter_repos
    @raw_repos.each do |raw_repo|
      raw_repo.select! { |key, _| ALLOWED_KEYS.include?(key) }

      collect_contributors_count(raw_repo)
      collect_commits_count(raw_repo)

      raw_repo["original_query"] = @original_query
    end
  end

  def collect_contributors_count(repo)
    repo["contributors_count"] = count_by_uri contributors_uri(repo["full_name"])
  end

  def collect_commits_count(repo)
    repo["commits_count"] = count_by_uri commits_uri(repo["full_name"])
  end

  def count_by_uri(uri)
    JSON.parse(Net::HTTP.get(uri)).count
  end

  def contributors_uri(repo_name)
    URI("https://api.github.com/repos/#{repo_name}/contributors")
  end

  def commits_uri(repo_name)
    URI("https://api.github.com/repos/#{repo_name}/commits")
  end
end
