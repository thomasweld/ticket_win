module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | TicketWin"
    end
  end

  def weekday_with_time(datetime)
    datetime.to_s(:weekday_with_time)
      .gsub(/0\d/) { |n| n[1] }
      .gsub(/AM|PM/, 'AM' => 'am', 'PM' => 'pm')
  end
end
