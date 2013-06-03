class Hand
  attr_accessor :cards, :bet, :finished

  def initialize(card)
    @cards = [card]
    @bet = 0
    @finished = false
  end

  def show
    @cards.map(&:name)
  end

  def values
    @cards.map(&:value)
  end

  def score
    raw_score = sum_card_values
    adjust_for_aces(raw_score)
  end

  def sum_card_values
    cards.inject(0) { |sum, card| sum + card.value }
  end

  def adjust_for_aces(raw_score)
    aces = cards.count { |card| card.is_ace }
    until raw_score < 22 || aces == 0
      raw_score -= 10
      aces -= 1
    end
    raw_score
  end
end