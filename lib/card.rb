class Card
  attr_accessor :is_ace
  attr_reader :name, :value

  FACECARDS = %w(J Q K)
  SUITS = %w(s d h c)
  VALUES = %w(A 2 3 4 5 6 7 8 9 10 J Q K)

  def initialize(value, suit)
    @value = value
    @suit = suit
    @name = "#{value}#{suit}"
    @is_ace = check_if_ace(value)
  end

  def value
    if FACECARDS.include?(@value)
      return 10
    elsif @value == "A"
      return 11
    else
      return @value.to_i
    end
  end

  def check_if_ace(value)
    value == "A" ? true : false
  end
end