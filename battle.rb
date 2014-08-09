class Unit
  $round = 1
  $firstAttackerName = ''
  $io=open("log.txt","w")
  def initialize(name,hp,str,defensive,luck)
    @hp = hp
    @str = str
    @defensive = defensive
    @luck = luck
    @name = name
  end

  attr_accessor :hp, :str, :defensive, :luck, :name

  def printStatus
    print @name, "\n", 'hp=', @hp, "\n", 'str=', @str, "\n", 'def=', @defensive, "\n", 'luck=', @luck, "\n", "\n"
  end

  def attack(enemy)
    if rand(0..99) < enemy.luck
      print @name, '의 공격이 빗나갔다!', "\n"
      printf($io,  @name + "의 공격이 빗나갔다!\n" )
    else
      damage = @str+(rand()*10).to_i-enemy.defensive
      if damage < 0
        damage = 0
      end
      enemy.hp = enemy.hp - damage
      if damage == @str+9-enemy.defensive
        print 'Critical Hit! ', @name, '은(는) ', enemy.name, '에게 ', damage, ' 만큼의 피해를 주었다.', "\n"
        printf($io,   "Critical Hit! %s은(는) %s에게 %d 만큼의 피해를 주었다.\n", @name,enemy.name,damage )
      else
        print @name, '은(는) ', enemy.name, '에게 ', damage, ' 만큼의 피해를 주었다.', "\n"
        printf($io,   "%s은(는) %s에게 %d 만큼의 피해를 주었다.\n", @name,enemy.name,damage )
      end
    end
  end


  def checkAlive
    if @hp < 0
      @hp = 0
      puts '', '우왕 주금 ㅠ'
      'death'
    else
      print @name, '은(는) ', @hp, '만큼 피가 남았다', "\n", "\n"
      printf($io, "%s 은(는) %d 만큼 피가 남았다.\n\n",@name,@hp)
      @alive
    end

  end


end


class Battle
  def fight(attacker, defender)
    #nil일떄 , attacker를 이름에 넣는다.
      if defender.checkAlive == @alive then
      $round = $round + 1
      if $round % 2 == 0
      print $round / 2, '번째 턴', "\n", "\n"
      printf($io, "%d번째 턴 \n\n", $round/2)
      end

      attacker.attack(defender)
      print '공격자 변환', "\n", '공격자는 ', defender.name, "\n"
      printf($io, "공격자 변환 \n공격자는 %s \n", defender.name )
      turnChange(attacker,defender)

    else
      print "\n", attacker.name, '의 승리'
      printf($io, "\n %s의 승리", attacker.name)
      $io.close
      exit false
    end

  end


  def turnChange(attacker,defender)
    attacker,defender = defender, attacker
    fight(attacker,defender)
  end

end
#변수를 묶어서.
unit1 =Unit.new("unit1",100+(rand()*10).to_i,20+(rand()*10).to_i,10+(rand()*10).to_i,10+(rand()*10).to_i)
unit1.printStatus
unit2 =Unit.new("unit2",100+(rand()*10).to_i,20+(rand()*10).to_i,10+(rand()*10).to_i,10+(rand()*10).to_i)
unit2.printStatus
puts "게임을 진행하시겠습니까? (y/n)"
access = gets.chomp
if access == "y"
  battle = Battle.new
  fistAttacker=[unit1, unit2].shuffle
  $firstAttackerName = fistAttacker[0].name
  print fistAttacker[0].name, '의 선공!', "\n", $round, '번째 턴!', "\n"
  battle.fight(fistAttacker[0], fistAttacker[1])
else
  exit false
end



