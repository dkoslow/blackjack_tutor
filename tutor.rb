class Tutor
  require_relative "player"

  def self.correct_play(player)
    card_values = []
    dealer_upcard = Dealer.hand.first.chop
    ten_cards = [10, "J","Q","K"]
    player.hand.each do |card|
      card_values.push(card.chop)
    end
    case card_values
    when ["2","2"]
      if ["2","3","4","5","6","7"].include?(dealer_upcard)
        "split"
      else
        "hit"
      end
    when ["3","3"]
      if ["2","3","4","5","6","7"].include?(dealer_upcard)
        "split"
      else
        "hit"
      end
    when ["4","4"]
      if ["5","6"].include?(dealer_upcard)
        "split"
      else
        "hit"
      end
    when ["5","5"]
      if ["2","3","4","5","6","7","8","9"].include?(dealer_upcard)
        "double_down"
      else
        "hit"
      end
    when ["6","6"]
      if ["2","3","4","5","6"].include?(dealer_upcard)
        "split"
      else
        "hit"
      end
    when ["7","7"]
      if ["2","3","4","5","6","7"].include?(dealer_upcard)
        "split"
      else
        "hit"
      end
    when ["8","8"]
      "split"
    when ["9","9"]
      if ["2","3","4","5","6","8","9"].include?(dealer_upcard)
        "split"
      else
        "stand"
      end
    when ["A","A"]
      "split"
    when (["A","2"] || ["2","A"])
      if ["5","6"].include?(dealer_upcard)
        "double_down"
      else
        "hit"
      end
    when (["A","3"] || ["3","A"])
      if ["5","6"].include?(dealer_upcard)
        "double_down"
      else
        "hit"
      end
    when (["A","4"] || ["4","A"])
      if ["4","5","6"].include?(dealer_upcard)
        "double_down"
      else
        "hit"
      end
    when (["A","5"] || ["5","A"])
      if ["4","5","6"].include?(dealer_upcard)
        "double_down"
      else
        "hit"
      end
    when (["A","6"] || ["6","A"])
      if ["3","4","5","6"].include?(dealer_upcard)
        "double_down"
      else
        "hit"
      end
    when (["A","7"] || ["7","A"])
      if ["3","4","5","6"].include?(dealer_upcard)
        "double_down"
      elsif ["2","7","8"].include?(dealer_upcard)
        "stand"
      else
        "hit"
      end
    else
      case player.score
      when 5
        "hit"
      when 6
        "hit"
      when 7
        "hit"
      when 8
        "hit"
      when 9
        if ["3","4","5","6"].include?(dealer_upcard)
          "double_down"
        else
          "hit"
        end
      when 10
        if ["2","3","4","5","6","7","8","9"].include?(dealer_upcard)
          "double_down"
        else
          "hit"
        end
      when 11
        if ["A"].include?(dealer_upcard)
          "hit"
        else
          "double_down"
        end
      when 12
        if ["4","5","6"].include?(dealer_upcard)
          "stand"
        else
          "hit"
        end
      when 13
        if ["2","3","4","5","6"].include?(dealer_upcard)
          "stand"
        else
          "hit"
        end
      when 14
        if ["2","3","4","5","6"].include?(dealer_upcard)
          "stand"
        else
          "hit"
        end
      when 15
        if ["2","3","4","5","6"].include?(dealer_upcard)
          "stand"
        else
          "hit"
        end
      when 16
        if ["2","3","4","5","6"].include?(dealer_upcard)
          "stand"
        else
          "hit"
        end
      when 17
        "stand"
      when 18
        "stand"
      when 19
        "stand"
      when 20
        "stand"
      end
    end
  end
end