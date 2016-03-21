require 'date'

class DetailParser < GitCounter
  def initialize(repo_name, start_date, end_date)
    @repo_name = repo_name

    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)

    # @stars = []
    # @commits = []

    @star_page = 1
    @commit_page = 1
  end

  def stargazers_statistics
    return cached_stars if cached_stars
    save_stars(Hash[filtered_stars.map{ |date, star| [date.to_s, star.count] }.sort])
  end

  def commits_statistics
    return cached_commits if cached_commits
    save_commits(Hash[filtered_commits.map{ |date, commit| [date.to_s, commit.count] }.sort])
  end

  def contributors_statistics
    return cached_contributors if cached_contributors
    save_contributors(
      Hash[filtered_commits.map{ |date, commit| [date.to_s, commit.uniq{ |commit| commit['commit']['author']['email'] }.count] }.sort]
    )
  end

  private
  def save_contributors(contributor_hash)
    Contributor.create(repo_name: @repo_name, start_date: @start_date, end_date: @end_date, result: contributor_hash)
    contributor_hash
  end

  def cached_contributors
    @cached_contributors ||= Contributor.where(
      repo_name: @repo_name, start_date: @start_date, end_date: @end_date
    ).pluck("result").first
  end

  def save_commits(commit_hash)
    Commit.create(repo_name: @repo_name, start_date: @start_date, end_date: @end_date, result: commit_hash)
    commit_hash
  end

  def cached_commits
    @cached_commits ||= Commit.where(repo_name: @repo_name, start_date: @start_date, end_date: @end_date).pluck("result").first
  end

  def filtered_commits
    @filtered_commits ||= grouped_commits.select do |date, _|
      date >= @start_date && date <= @end_date
    end
  end

  def grouped_commits
    @grouped_commits ||= commits.group_by do |commit|
      commit_date = Date.parse(commit['commit']['author']['date'])
    end
  end

  def save_stars(star_hash)
    Stargazer.create(repo_name: @repo_name, start_date: @start_date, end_date: @end_date, result: star_hash)
    star_hash
  end

  def cached_stars
    @cached_stars ||= Stargazer.where(repo_name: @repo_name, start_date: @start_date, end_date: @end_date).pluck("result").first
  end

  def filtered_stars
    @filtered_stars ||= grouped_stars.select do |date, _|
      date >= @start_date && date <= @end_date
    end
  end

  def grouped_stars
    @grouped_stars ||= stars.group_by do |star|
      star_date = Date.parse(star['starred_at'])
    end
  end
end
