module ApplicationHelper

  def to_currency(value = 0.0, options = {})
    content_tag :span, {:class => (value >= 0 ? "positive" : "negative")}.merge(options) do
      number_with_precision(value, :precision => 2)
    end
  end

  def to_number(value = 0.0)
    number_with_precision(value, :precision => 2) if value
  end

  def to_date(date = Date.today)
    localize(date, :format => :default) if date
  end

end
