namespace :gocardless do
  desc "Update payment data from gocardless"
  task :fetch => :environment do
    raise "Set GOCARDLESS credentials in ENV" unless GOCARDLESS_MERCHANT
    GocardlessFetcher.new.fetch
  end
end