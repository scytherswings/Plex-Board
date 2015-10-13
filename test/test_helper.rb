ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
require "strip_attributes/matchers"
require 'webmock/minitest'
# require 'helpers/fake_plextv'
Minitest::Reporters.use!
WebMock.disable_net_connect!(:allow_localhost => true)


class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  include StripAttributes::Matchers


  # Add more helper methods to be used by all tests here...
end






