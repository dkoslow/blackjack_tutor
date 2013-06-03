class Game
  require_relative "player"
  require_relative "dealer"
  require_relative "console"

  class << self
    attr_accessor :num_players, :test_mode

    def play_round
      set_up_game
      request_bets
      deal_starting_hands
      show_game_status
      begin_gameplay
      print_outcomes
    end

    def set_up_game
      set_game_mode
      set_players
      Shoe.create_shoe unless @test_mode == true
    end

    def set_game_mode
      if Player.players.count < 1
        puts "Would you like to play in test mode(yes/no)? "
        mode = gets.chomp || "no"
        if mode == "yes"
          @test_mode = true
        end
      end
    end

    def set_players
      @num_players ||= set_num_players
      Player.players.count > 0 ? Player.players : set_player_names
    end

    def set_num_players
      puts "Enter number of players:"
      gets.to_i || 1
    end

    def set_player_names
      @num_players.times do |i|
        puts "Enter player #{i + 1} name:"
        name = gets.chomp || "Test"
        Player.new(name)
      end
      Player.players
    end

    def deal_starting_hands
      clear_hands_if_necessary
      initialize_hands
      complete_hands
    end

    def clear_hands_if_necessary
      if Player.players.first.hands.first
        Player.players.each { |player| player.clear_hand}
        Dealer.clear_hand
      end
    end

    def initialize_hands
      set_player_hands
      set_dealer_hand
    end

    def set_player_hands
      Player.players.each do |player|
        card = Shoe.deal_card(player.name)
        hand = Hand.new(card)
        player.hands << hand
        player.current_hand.bet = player.initial_bet
      end
    end

    def set_dealer_hand
      card = Shoe.deal_card(Dealer.name)
      Dealer.hand = Hand.new(card)
    end

    def complete_hands
      Player.players.each { |player| player.hit(player.current_hand) }
      Dealer.hit(Dealer.current_hand)
    end

    def show_game_status
      Player.players.each do |player|
        Console.show_hand(player)
        Console.show_score(player)
      end
      Dealer.show_starting_hand
    end

    def begin_gameplay
      Player.players.each do |player|
        player.request_action
      end
      Dealer.play_game
    end

    def request_bets
      Player.players.each { |player| player.request_bet }
    end

    def print_outcomes
      Player.players.each do |player|
        player.hands.each do |hand|
          Console.print_hand_number(player, hand) if player.hands.count > 1
          Console.print_result(player, hand)
          Console.show_money(player)
        end
      end
    end
  end
end

while true
  Game.play_round
  puts "Another hand? (enter 'no' to quit)"
  if gets.chomp.downcase == ("no")
    break
  end
end