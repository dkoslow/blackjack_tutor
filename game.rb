class Game
  require_relative "player"
  require_relative "dealer"

  class << self
    attr_accessor :num_players

    def play_round
      set_players
      deal_starting_hands
      begin_gameplay
      evaluate_outcome
    end

    def set_players
      @num_players ||= set_num_players
      Player.players.count > 0 ? Player.players : Player.players = set_player_names
    end

    def set_num_players
      puts "Enter number of players:"
      gets.to_i || 1
    end

    def set_player_names
      count = 1
      @num_players.times do |player|
        puts "Enter player #{count} name:"
        Player.new(gets)
        count += 1
      end
      Player.players
    end

    def deal_starting_hands
      Player.players.each { |player| player.clear_hand }
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
          player.split_score = player.score
          player.hand = player.split_hand
          player.request_action
          player.determine_better_hand
        end
      end
      Dealer.play_game
    end

    def evaluate_outcome
      Player.players.each do |player|
        case 
        when player.score > 21
          player.result = "#{player.name.chomp}, you busted with a score of #{player.score}. You lose."
        when player.score < Dealer.score
          if Dealer.score <= 21
            player.result = "#{player.name.chomp}, you lost with a score of #{player.score}."
          else
            player.result = "#{player.name.chomp}, you won with a score of #{player.score}!"
          end
        when player.score > Dealer.score
          player.result = "#{player.name.chomp}, you won with a score of #{player.score}!"
        when player.score == Dealer.score
          player.result = "#{player.name.chomp}, you pushed with a score of #{player.score}."
        end
        puts "#{player.result}"
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