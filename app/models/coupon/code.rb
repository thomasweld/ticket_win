class Coupon::Code
  attr_reader :code

  def initialize
    @code = generate
  end

  private

  def generate
    Array.new(10) { valid_chars.sample }.join
  end

  def valid_chars
    @@valid ||= [ *0..9, *'A'..'Z' ] - [ 0, 'O', 1, 'I' ]
  end
end
