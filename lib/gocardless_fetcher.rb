class GocardlessFetcher
  def initialize(merchant = nil)
    @merchant = merchant || GOCARDLESS_MERCHANT.call
  end

  def fetch
    @merchant.bills.each do |remote_bill|
      local_bill = GocardlessBill.find_or_create_by_gocardless_id(remote_bill.id)
      %w{amount created_at description name status merchant_id user_id source_type source_id}.each do |attribute|
        local_bill.send("#{attribute}=", remote_bill.send(attribute))
      end
      remote_user = remote_bill.user
      %w{email first_name last_name}.each do |attribute|
        local_bill.send("user_#{attribute}=", remote_user.send(attribute))
      end
      local_bill.reservation ||= local_bill.find_matching_reservation
      local_bill.save
    end
  end

end