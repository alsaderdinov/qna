module ApplicationHelper

  def current_yer
    Time.current.year
  end

  def github_url(author, repo)
    "https://github.com/#{author}/#{repo}"
  end
end
