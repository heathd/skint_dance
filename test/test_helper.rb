ENV["RAILS_ENV"] = "test"
$LOAD_PATH << File.expand_path("../../lib", __FILE__)
$LOAD_PATH << File.expand_path("../../", __FILE__)

require "config/environment"
require "rails/test_help"

require "db/seeds/ticket_types"

