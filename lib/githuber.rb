require 'date'

class Githuber
  attr_reader :mode

  include GithubApi

  # keys which will be deleted during filtering to save space
  UNUSED_KEYS = ['owner', 'teams_url', 'hooks_url', 'events_url', 'assignees_url',
    'branches_url', 'tags_url', 'blobs_url', 'git_tags_url', 'git_refs_url',
    'trees_url', 'statuses_url', 'languages_url',
    'subscribers_url', 'subscription_url', 'git_commits_url', 'comments_url',
    'issue_comment_url', 'contents_url', 'compare_url', 'merges_url', 'archive_url',
    'downloads_url', 'issues_url', 'pulls_url', 'milestones_url', 'notifications_url',
    'labels_url', 'releases_url', 'deployments_url', 'homepage', 'issue_events_url']

  def initialize(mode = :weekly)
    @mode = mode
  end

  def repos
    @repos ||= get_repos
  end

  def orgs
    @orgs ||= get_orgs
  end

  def query
    @query ||= "created:#{date_range}"
  end

  private
  def get_orgs
    return cached_orgs if cached_orgs

    raw_result = filter_data parse_response(orgs_request)
    save_orgs(raw_result)
  end

  def cached_orgs
    @cache ||= OrgsRawResult.where(original_query: query).pluck("result").first
  end

  def save_orgs(raw_result)
    OrgsRawResult.create(result: raw_result, original_query: query)
    raw_result
  end

  def get_repos
    return cached_repos if cached_repos

    raw_result = filter_data parse_response(repos_request)
    save_repos(raw_result)
  end

  def cached_repos
    @cache ||= RepoRawResult.where(original_query: query).pluck("result").first
  end

  def save_repos(raw_result)
    RepoRawResult.create(result: raw_result, original_query: query)
    raw_result
  end

  def date_range
    range = (@mode == :weekly) ? 8 : 31
    "#{range.days.ago.strftime('%Y-%m-%d')}..#{Date.today.strftime('%Y-%m-%d')}"
  end

  # we need to filter data due to save space and remove a lot of unused information
  def filter_data(data)
    data["items"].each do |repo|
      UNUSED_KEYS.each { |unused_key| repo.delete(unused_key) }
    end
  end
end
