module EntriesHelper

  @@month_names ||= I18n.translate("date.month_names")

  def pay_status(entry)

    case
      when entry.pending? then "pending"
      when entry.overdue? then "overdue"
      when entry.paid? then "paid"
      else "active"
    end

  end

  def date_filter_options

    months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    now = Date.today

    options = []
    options << ["Ano passado (#{now.year-1})", months.collect { |m| ["#{@@month_names[m]}/#{now.year-1}", "#{m}-#{now.year-1}"] } ]
    options << ["Este ano (#{now.year})", months.collect { |m| ["#{@@month_names[m]}/#{now.year}", "#{m}-#{now.year}"] } ]
    options << ["Ano que vem (#{now.year+1})", months.collect { |m| ["#{@@month_names[m]}/#{now.year+1}", "#{m}-#{now.year+1}"] } ]

  end

end
