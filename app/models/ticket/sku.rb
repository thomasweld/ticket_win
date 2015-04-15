class Ticket::SKU

  attr_reader :sku
  alias_method :to_s, :sku

  def initialize(ticket=nil)
    @prefix = ticket.try(:event_id) || ?X
    @affix = affix
    @sku = "#{@prefix}#{@affix}"
  end

  private

  def affix
    Array.new(6) { valid_chars.sample }.join
  end

  def valid_chars
    @valid ||= [ *0..9, *'A'..'Z' ] - [ 0, 'O', 1, 'I' ]
  end
end
