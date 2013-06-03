class Shoe
  require_relative "card"
  class << self

    def create_shoe
      @cards = []
      num_decks.times do
        create_deck
        @cards.push(@deck)
      end
      @cards.flatten!.shuffle!
    end

    def num_decks
      @num_decks ||= set_num_decks
    end

    def set_num_decks
      Console.get_deck_number
    end

    def cards
      @cards ||= []
    end

    def create_deck
      clear_deck
      Card::VALUES.each do |value|
        Card::SUITS.each do |suit|
          @deck << Card.new(value, suit)
        end
      end
    end

    def clear_deck
      @deck = []
    end

    def deal_card(player_name)
      if Game.test_mode == true
        card_name = Console.set_card(player_name)
        Card.new(card_name.chop, card_name.reverse[0])
      else
        create_shoe if Shoe.cards.size < 1
        @cards.shift
      end
    end
  end
end