class Dealer
  require_relative "gameplay_actions"

  class << self
    include GameplayActions

    attr_reader :hand

    def name
      "Dealer"
    end

    def show_starting_hand
      print "Dealer's hand is [#{hand.first}, X].\n"
    end

    def play_game
      while true
        show_hand
        show_score
        case
        when score < 17
          hit
        when score >= 17
          break
        end
      end
    end
  end
end