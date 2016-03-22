module ParserHelper
  def date_in_bounds?(mode)
    left_date, _ = @original_query[8..-1].split('..')
    start_date = Date.parse(left_date)

    start_date <= criteria_start_date(mode)
  end

  def criteria_start_date(mode)
    case mode
    when 'weekly'
      8
    when 'monthly'
      31
    end.days.ago.to_date
  end
end
