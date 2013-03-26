module GameplayActions
  require_relative "shoe"

  def hit
    card = Shoe.deal_card
    @hand.push(card)
  end

  def clear_hand
    @hand = []
  end

  def show_hand
    print "#{name.chomp}'s hand is #{hand}.\n"
  end

  def show_score
    print "#{name.chomp}'s score is #{score}.\n"
  end

  def score
    total
    if @ace_count > 0
      if @total > 21
        @total -= 10
        @ace_count -= 1
      end
    end
    @total
  end

  def total
    @ace_count = 0
    @total = @hand.inject(0) do |total, card|
      if card.chop.to_i > 0
        total + card.chop.to_i
      elsif card[0] == "A"
        @ace_count += 1
        total + 11
      elsif %w(J Q K).include?(card[0])
        total + 10
      else
        raise ArgumentError, "Card value is not valid."
      end
    end
  end
end