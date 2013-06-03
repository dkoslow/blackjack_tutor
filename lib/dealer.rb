class Dealer
  require_relative "shoe"

  class << self
    attr_writer :hand

    def name
      "Dealer"
    end

    def current_hand
      hand
    end

    def hand
      @hand ||= []
    end

    def hit(hand)
      card = Shoe.deal_card(self.name)
      hand.cards << card
    end

    def clear_hand
      self.hand.cards.clear
    end

    def show_starting_hand
      if Game.test_mode == true
        Console.print_hand_status(self)
      else
        Console.print_dealer_hidden_hand_status(upcard.name)
      end
    end

    def upcard
      @hand.cards.first
    end

    def play_game
      while true
        Console.print_hand_status(self)
        case
        when @hand.score < 17
          hit(current_hand)
        when @hand.score >= 17
          break
        end
      end
    end
  end
end