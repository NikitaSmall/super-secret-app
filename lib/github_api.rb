module GithubApi
  def repos_request
    # per_page count reduced explicitly due to reducing time of request. 2N+1 requests aren't joke!
    Net::HTTP.get(URI("https://api.github.com/search/repositories?per_page=50&q=#{query}&#{api_credentials}"))
  end

  def orgs_request
    # per_page count reduced explicitly due to reducing time of request. There is near orgs_number * repo_in_org_number + 1 request.
    Net::HTTP.get(URI("https://api.github.com/search/users?page=19&per_page=50&sort=repositories&q=type:org+#{query}&#{api_credentials}"))
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
    Net::HTTP.get(URI("https://api.github.com/repos/#{@repo_name}/commits?page=#{@commit_page}&per_page=100&#{api_credentials}"))
  end

  def orgs_repos_request(orgs_name)
    Net::HTTP.get(URI("https://api.github.com/orgs/#{orgs_name}/repos?per_page=100&#{api_credentials}"))
  end

  def members_request(orgs_name)
    Net::HTTP.get(URI("https://api.github.com/orgs/#{orgs_name}/members?per_page=100&#{api_credentials}"))
  end

  def api_credentials
    "client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
  end

  def parse_response(request_result)
    JSON.parse(request_result)
  end
end
