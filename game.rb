class Game
  require_relative "player"
  require_relative "dealer"

  class << self
    attr_accessor :num_players, :test_mode

    def play_round
      set_game_mode
      set_players
      request_bets
      deal_starting_hands
      begin_gameplay
      evaluate_outcome
    end

    def set_game_mode
      if Player.players.count < 1
        puts "Would you like to play in test mode(yes/no)? "
        mode = gets.chomp
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
        name = gets.chomp
        Player.new(name)
      end
      Player.players
    end

    def deal_starting_hands
      Player.players.each { |player| player.clear_hand }
      Player.players.each { |player| player.clear_split_hand }
      Dealer.clear_hand
      2.times do
        Player.players.each { |player| player.hit }
        Dealer.hit
      end
      Player.players.each do |player|
        player.show_hand
        player.show_score
      end
      Dealer.show_starting_hand
    end

    def begin_gameplay
      Player.players.each do |player|
        player.request_action
        if player.split_hand.any?
          player.flip_hands
          player.request_action
        end
      end
      Dealer.play_game
    end

    def request_bets
      Player.players.each { |player| player.request_bet }
    end

    def evaluate_outcome
      Player.players.each do |player|
        player.print_result
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