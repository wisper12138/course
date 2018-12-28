# 注意这里必须在 require rails/test_help 之前加入，否则不会生效
require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  
  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
    def log_in_as(user, password: 'password', remember_me: '1')
    post sessions_login_path(params: {session: { email: user.email,
                                                 password: password,
                                                 remember_me: remember_me } })
  end
end