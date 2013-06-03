module Console
  class << self

    def print_hand_status(player)
      show_hand(player)
      show_score(player)
    end

    def print_dealer_hidden_hand_status(upcard)
      puts "Dealer's hand is [#{upcard}, X]."
    end

    def show_hand(player)
      puts "#{player.name}'s hand is #{player.current_hand.show}."
    end

    def show_score(player)
      puts "#{player.name}'s score is #{player.current_hand.score}."
    end

    def set_card(player_name)
      puts "What card would you like to deal for #{player_name}?"
      card = gets.chomp
    end

    def get_deck_number
      puts "Enter number of decks:"
      gets.to_i || 6
    end

    def print_finances(player)
      show_bet(player)
      show_money(player)
    end

    def show_bet(player)
      puts "#{player.name}'s bet is #{player.current_hand.bet}."
    end

    def show_money(player)
      puts "#{player.name} has $#{player.money}."
    end

    def print_correct_play(play, correct_play)
      if play == correct_play
        puts "Correct play!"
      else
        puts "Incorrect play. Correct play was #{correct_play}."
      end
    end

    def print_lack_of_money_warning(action)
      puts "You do not have enough money to #{action}."
    end

    def print_invalid_action_warning
      puts "That is not a valid action."
    end

    def print_illegal_action_warning(action)
      puts "You cannot #{action} with that hand."
    end

    def print_final_score(name, score)
      puts "#{name}, your final score is #{score}."
    end

    def get_action(player)
      puts "#{player.name}, what would you like to do? (enter 'hit', 'stand', 'split', or 'double down')"
      gets.chomp.to_s
    end

    def get_bet(player)
      amount = player.money + 1
      until amount <= player.money && amount > 0
        puts "#{player.name}, how much would you like to bet? "
        amount = gets.to_i 
      end
      amount
    end

    def print_hand_number(player, hand)
      index = player.hands.index(hand)
      puts "For hand number #{index + 1} (#{hand.show}):"
    end

    def print_result(player, hand)
      puts player.determine_result(hand)
    end
  end
end