class Shoe
  class << self

    def create_shoe
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
      puts "Enter number of decks:"
      gets.to_i || 6
    end

    def cards
      @cards ||= []
    end

    def create_deck
      clear_deck
      suits = %w(s d h c)
      values = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
      values.each do |value|
        suits.each do |suit|
          @deck.push(value + suit)
        end
      end
    end

    def clear_deck
      @deck = []
    end

    def deal_card(name)
      if Game.test_mode == true
        puts "What card would you like to deal for #{name.chomp}?"
        card = gets.chomp
      else
        create_shoe if Shoe.cards.size < 1
        @cards.shift
      end
    end
  end
end