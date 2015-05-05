class Order::RedemptionCode

  attr_reader :redemption_code
  alias_method :to_s, :redemption_code

  def initialize
    @redemption_code = generate
  end

  private

  def generate
    Array.new(25) { valid_chars.sample }.join
  end

  def valid_chars
    @valid ||= [ *0..9, *'A'..'Z', *'a'..'z' ]
  end
end
