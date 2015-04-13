module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | TicketWin"
    end
  end
end
