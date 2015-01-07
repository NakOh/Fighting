
class Player

  def play_turn(warrior)

    if @health == nil
      @health = warrior.health
    end
    health = warrior.health
    attack=attacked(health)

    if warrior.feel.wall? == true
      warrior.pivot!
    else
      if attack == true
        if warrior.feel.enemy?
          warrior.attack!
        elsif warrior.feel.empty? and warrior.health < 10
          warrior.walk!:backward
        elsif warrior.feel.empty?
          warrior.walk!
        else
          warrior.rescue!
        end

      else
        vision = warrior.look(:forward)
        if warrior.health < 20
          warrior.walk!:backward
        elsif warrior.feel.enemy?
          warrior.attack!
        elsif vision.index.enemy? == true
          warrior.shoot!
        elsif warrior.feel.empty?
          warrior.walk!
        else warrior.feel.captive?
        warrior.rescue!

        end
      end
    end

    @health = warrior.health
  end


  def attacked(health)
    if @health > health
      return true
    else
      return false
    end
  end

end