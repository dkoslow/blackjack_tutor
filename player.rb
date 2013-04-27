class Player
  require_relative "gameplay_actions"
  require_relative "tutor"

  include GameplayActions

  attr_accessor :result, :split_score, :hand, :split_hand, :bet, :split_bet, :money
  attr_reader :name
  attr_writer :score

  class << self
    attr_writer :players

    def players
      @players ||= []
    end
  end

  def initialize(name = "Guest")
    @name = name
    @hand = []
    @total = 0
    @split_hand = []
    @money = 1000
    @bet = 0
    @split_bet = nil
    Player.players.push(self)
  end

  def request_action
    while true
      show_hand
      show_score
      show_bet
      show_money
      break if score > 20
      puts "#{name}, what would you like to do? (enter 'hit', 'stand', 'split', or 'double down')"
      action = gets.to_s.chomp
      correct_action?(action)
      case action
      when "hit"
        hit
      when "split"
        if @split_hand.any?
          puts "You can only split once."
        elsif @money < @bet
          puts "You do not have enough money to split."
        elsif @hand.size == 2
          first_card = @hand.first.chop
          second_card = @hand.last.chop
          if first_card == second_card
            split_cards
          elsif %w(J Q K 10).include?(first_card)
            if %w(J Q K 10).include?(second_card)
              split_cards
            end
          else 
            puts "You cannot split that hand."
          end
        else
          puts "You cannot split that hand."
        end
      when "double down"
        if @money < @bet
          puts "You do not have enough money to double down."
        elsif @hand.size == 2
          @money -= @bet
          @bet *= 2
          show_bet
          show_money
          hit
          show_hand
          puts "#{name}, your final score is #{score}."
          break
        else
          puts "You cannot double down with that hand."
        end
      when "stand"
        puts "#{name}, your final score is #{score}."
        break
      else
        puts "That is not a valid action."
      end
    end
  end

  def print_result
    case 
    when score > 21
      @result = "#{name}, you busted with a score of #{score}. You lose."
    when score < Dealer.score
      if Dealer.score <= 21
        @result = "#{name}, you lost with a score of #{score}."
      else
        @result = "#{name}, you won with a score of #{score}!"
        check_for_blackjack
        win_payout
      end
    when score > Dealer.score
      @result = "#{name}, you won with a score of #{score}!"
      check_for_blackjack
      win_payout
    when score == Dealer.score
      if score != 21
        @result = "#{name}, you pushed with a score of #{score}."
        push_payout
      else
        if hand.count == 2
          if Dealer.hand.count == 2
            check_for_blackjack
          else
            @result = "#{name}, you won with a score of blackjack!"
            win_payout
          end
        else
          if Dealer.hand.count == 2
            @result = "#{name}, you lost with a score of #{score}."
          else
            @result = "#{name}, you pushed with a score of #{score}."
            push_payout
          end
        end
      end
    end
    puts "#{@result}"
    show_money
    if @split_hand.any?
      flip_hands
      clear_split_hand
      print_result
    end
  end

  def split_cards
    card = @hand.pop
    @split_hand.push(card)
    @split_bet = @bet
    @money -= @split_bet
  end

  def clear_split_hand
    @split_hand = []
    @split_score = nil
    @split_bet = nil
  end

  def flip_hands
    @split_score = @score
    previous_hand = @hand
    @hand = @split_hand
    @split_hand = previous_hand
    previous_bet = @bet
    @bet = @split_bet
    @split_bet = previous_bet
  end

  def check_for_blackjack
    if self.score == 21
      if self.hand.count == 2
        self.result = "#{self.name}, you won with a score of blackjack!"
        self.bet = Integer(self.bet * 1.25)
      end
    end
  end

  def correct_action?(play)
    correct_play = Tutor.correct_play(self)
    if play == correct_play
      puts "Correct play!"
    else
      puts "Incorrect play. Correct play was #{correct_play}."
    end
  end

  def request_bet
    amount = @money + 1
    until amount <= @money && amount > 0
      puts "How much would you like to bet? "
      amount = gets.to_i 
    end
    @bet = amount
    @money -= @bet
  end

  def show_bet
    puts "#{name}'s bet is #{bet}."
  end

  def show_money
    puts "#{name} has $#{money}."
  end

  def push_payout
    @money += @bet
  end

  def win_payout
    @money += @bet * 2
  end
end