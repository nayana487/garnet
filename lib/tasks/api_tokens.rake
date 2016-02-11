namespace :api do
  desc "Generates API tokens for all users which don't have one"
  task "generate_user_tokens" => :environment do
    users_without_tokens = User.where(api_token: nil)
    users_without_tokens.each(&:generate_api_token)
  end
end
