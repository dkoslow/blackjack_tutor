class Player
  require_relative "gameplay_actions"
  require_relative "tutor"

  include GameplayActions

  attr_accessor :result, :split_score, :hand, :split_hand
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
    Player.players.push(self)
  end

  def request_action
    while true
      show_hand
      show_score
      break if score > 20
      puts "#{name.chomp}, what would you like to do? (enter 'hit', 'stand', 'split', or 'double down')"
      action = gets.to_s.chomp
      correct_action?(action)
      case action
      when "hit"
        hit
      when "split"
        if @split_hand.any?
          puts "You can only split once."
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
        if @hand.size == 2
          hit
          show_hand
          puts "#{name.chomp}, your final score is #{score}."
          break
        else
          puts "You cannot double down with that hand."
        end
      when "stand"
        puts "#{name.chomp}, your final score is #{score}."
        break
      else
        puts "That is not a valid action."
      end
    end
  end

  def split_cards
    card = @hand.pop
    @split_hand.push(card)
  end

  def clear_split_hand
    @split_hand = []
    @split_score = nil
  end

  def determine_better_hand
    case
    when self.score > 21
      self.hand = self.split_hand
      self.score = self.split_score
    when self.split_score > self.score
      if self.split_score <= 21
        self.hand = self.split_hand
        self.score = self.split_score
      end
    when self.split_score == self.score
      if self.score == 21
        if self.split_hand.count == 2
          self.hand = self.split_hand
        end
      end
    end
  end

  def check_for_blackjack
    if self.score == 21
      if self.hand.count == 2
        self.result = "#{self.name.chomp}, you won with a score of blackjack!"
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
end