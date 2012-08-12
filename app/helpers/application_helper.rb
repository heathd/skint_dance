module ApplicationHelper
  def markdown_to_html(&block)
    content = capture(&block)
    return RDiscount.new(content).to_html.html_safe
  end
end
