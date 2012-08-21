GoCardless.account_details = {
  :app_id     => ENV["GOCARDLESS_APP_ID"],
  :app_secret => ENV["GOCARDLESS_APP_SECRET"],
  :token      => ENV["GOCARDLESS_TOKEN"] + " manage_merchant:" + ENV["GOCARDLESS_MERCHANT_ID"]
}

GOCARDLESS_MERCHANT = lambda {
  gocardless_merchant = nil
  lambda { gocardless_merchant ||= GoCardless::Merchant.find(ENV["GOCARDLESS_MERCHANT_ID"]) }
}.call