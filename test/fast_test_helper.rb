ENV["RAILS_ENV"] = "test"
$LOAD_PATH << File.expand_path("../../lib", __FILE__)
$LOAD_PATH << File.expand_path("../../", __FILE__)

require 'test/unit'
require 'active_support/test_case'
require "db/seeds/ticket_types"

