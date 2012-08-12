module ApplicationHelper
  def markdown_to_html(&block)
    content = capture(&block)
    return RDiscount.new(content).to_html.html_safe
  end

  def payment_methods
    [
      ["UK residents, using Go Cardless secure direct debit", :gocardless],
      ["International, using paypal (costs us more)", :paypal],
      ["Cheque", :cheque]
    ]
  end
end
