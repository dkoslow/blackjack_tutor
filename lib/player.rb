class Player
  require_relative "tutor"
  require_relative "hand"
  require_relative "shoe"

  attr_accessor :money, :hands, :initial_bet
  attr_reader :name

  class << self
    attr_writer :players

    def players
      @players ||= []
    end
  end

  def initialize(name = "Guest")
    @name = name
    @hands = []
    @money = 1000
    @initial_bet = 0
    Player.players.push(self)
  end

  def current_hand
    @hands.detect { |hand| hand.finished == false }
  end

  def split_hand
    new_hand = Hand.new(current_hand.cards.pop)
    new_hand.bet = current_hand.bet
    @money -= new_hand.bet
    @hands << new_hand
  end

  def hit(hand)
    card = Shoe.deal_card(self.name)
    hand.cards << (card)
  end

  def clear_hand
    self.hands = []
  end

  def request_action
    until !current_hand
      Console.print_hand_status(self)
      Console.print_finances(self)
      if current_hand.score > 20
        current_hand.finished = true
      else
        action = Console.get_action(self)
        process_action(action)
      end
    end
  end

  def process_action(action)
    correct_action?(action)
    case action
    when "hit"
      hit(current_hand)
    when "split"
      handle_split
    when "double down"
      if @money < current_hand.bet
        Console.print_lack_of_money_warning(action)
      elsif current_hand.cards.count == 2
        handle_double_down
        current_hand.finished = true
      else
        Console.print_illegal_action_warning(action)
      end
    when "stand"
      Console.print_final_score(name, current_hand.score)
      current_hand.finished = true
    else
      Console.print_invalid_action_warning
    end
  end

  def determine_result(hand)
    result = ""
    case 
    when hand.score > 21
      result = "#{name}, you busted with a score of #{hand.score}. You lose."
    when hand.score < Dealer.hand.score
      if Dealer.hand.score <= 21
        result = "#{name}, you lost with a score of #{hand.score}."
      else
        result = "#{name}, you won with a score of #{hand.score}!"
        result = check_for_blackjack(hand) || result
        collect_winnings("win", hand)
      end
    when hand.score > Dealer.hand.score
      result = "#{name}, you won with a score of #{hand.score}!"
      result = check_for_blackjack(hand) || result
      collect_winnings("win", hand)
    when hand.score == Dealer.hand.score
      if hand.score != 21
        result = "#{name}, you pushed with a score of #{hand.score}."
        collect_winnings("push", hand)
      else
        if hand.count == 2
          if Dealer.hand.count == 2
            result = check_for_blackjack(hand)
          else
            result = "#{name}, you won with a score of blackjack!"
            collect_winnings("win", hand)
          end
        else
          if Dealer.hand.count == 2
            result = "#{name}, you lost with a score of #{hand.score}."
          else
            result = "#{name}, you pushed with a score of #{hand.score}."
            collect_winnings("push", hand)
          end
        end
      end
    end
    result
  end

  def handle_split
    if @money < current_hand.bet
      Console.print_lack_of_money_warning(action)
    elsif current_hand.cards.count == 2
      if current_hand.cards.first.value == current_hand.cards.last.value
        split_hand
      else
        Console.print_illegal_action_warning(action)
      end
    else
      Console.print_illegal_action_warning(action)
    end
  end

  def handle_double_down
    @money -= current_hand.bet
    current_hand.bet *= 2
    Console.print_finances(self)
    hit(current_hand)
    Console.show_hand(self)
    Console.print_final_score(name, current_hand.score)
  end

  def check_for_blackjack(hand)
    if hand.score == 21
      if hand.cards.count == 2
        hand.bet = Integer(hand.bet * 1.25)
        return "#{name}, you won with a score of blackjack!"
      end
    end
  end

  def correct_action?(play)
    correct_play = Tutor.correct_play(current_hand)
    Console.print_correct_play(play, correct_play)
  end

  def request_bet
    @initial_bet = Console.get_bet(self)
    @money -= @initial_bet
  end

  def collect_winnings(outcome, hand)
    if outcome == "win"
      @money += hand.bet * 2
    elsif outcome == "push"
      @money += hand.bet
    else
      raise ArgumentError.new("Outcome should be 'win' or 'push'")
    end
  end
end