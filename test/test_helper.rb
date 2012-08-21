ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require_relative "../db/seeds/ticket_types"

class ActiveSupport::TestCase
end
