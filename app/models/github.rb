class Github

  Octokit.auto_paginate = true
  attr_accessor :user_code, :token

  def initialize env = nil, token = nil
    @env = env
    @token = token
  end

  def get_user_by_id id
    # This is an undocumented endpoint for some reason
    # Documentation exists only for using "username", not id
    query = {
      client_id: @env["gh_client_id"],
      client_secret: @env["gh_client_secret"]
    }.to_query
    url = "https://api.github.com/user/#{id}?#{query}"
    api_response = HTTParty.get(url)
    if api_response.code > 400
      raise "Looks like some API trouble. #{api_response.code} #{api_response.to_json}"
    end
    return {
      github_id: api_response["id"],
      username: api_response["login"].downcase,
      image_url: api_response["avatar_url"],
      name: api_response["name"],
      email: api_response["email"]
    }
  end

  def user_info username = nil
    api_response = api.user(username)
    return {
      github_id: api_response["id"],
      username: api_response["login"].downcase,
      image_url: api_response["avatar_url"],
      name: api_response["name"],
      email: api_response["email"]
    }
  end

  def api
    if @token
      return Octokit::Client.new(access_token: @token)
    else
      return Octokit::Client.new(client_id: @env["gh_client_id"], client_secret: @env["gh_client_secret"])
    end
  end

  def oauth_link
    params = {
      client_id: @env["gh_client_id"],
      redirect_uri: @env["gh_redirect_url"]
    }
    return "https://github.com/login/oauth/authorize?#{params.to_query}"
  end

  def get_access_token user_code
    @token = HTTParty.post(
      "https://github.com/login/oauth/access_token",
      {
        body: {
          client_id: @env["gh_client_id"],
          client_secret: @env["gh_client_secret"],
          code: user_code
        }
      }
    ).split("&")[0].split("=")[1]
    return @token
  end

  def repo org_slash_repo
    JSON.parse(HTTParty.get("https://api.github.com/repos/#{org_slash_repo}").body)
  end

  def issues org_slash_repo, url = nil, all_issues = []
    url ||= "https://api.github.com/repos/#{org_slash_repo}/issues?access_token=#{@token}"
    github_issues = HTTParty.get(url)
    JSON.parse(github_issues.body).each do |issue|
      all_issues << issue
    end
    next_url = github_issues.headers["link"].match /<(.*)>; rel="next"/
    if next_url
      url = next_url[1]
      issues org_slash_repo, url, all_issues
    end
    all_issues
  end

end
