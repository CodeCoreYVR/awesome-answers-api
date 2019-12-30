Rails.application.config.middleware.use OmniAuth::Builder do
  # To get a Github ID and secret, you must create
  # a github developer application. This is the same
  # process that you have to do with pretty much every
  # provider
  provider :github, ENV["GITHUB_ID"], ENV["GITHUB_SECRET"], scope: "read:user, user:email"
end
