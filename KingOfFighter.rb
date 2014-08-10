class Unit
  def initialize (name,hp,mp,str,defensive,luck)
    #각 유닛마다 랜덤하게 능력치를 정함
    @log_print = Print.new
    @attack_type=Attack_Type.new
    @name = name
    @mp = mp
    @hp = hp+(rand*10).to_i
    @str = str+(rand*10).to_i
    @defensive = defensive+(rand*10).to_i
    @luck = luck+(rand*10).to_i
  end

  attr_accessor :hp, :str, :defensive, :luck, :name, :mp

  def print_unit_status
    #로그라는 변수에 문자열을 저장 후 출력
    log = "#{@name}\nhp=#{@hp}\nstr=#{@str}\ndef=#{@defensive}\nluck=#{@luck}\n\n"
    @log_print.console_print(log)
    @log_print.text_print(log)
  end

  def attack(enemy)#상대편을 공격
    #확률적으로 luck에 따라 상대방의 luck에 따라서 공격이 빗나갈 수 있고, 크리티컬이 터질 수도 있음 마법공격도 가능
    damage = @str-enemy.defensive
    #attack발동
    if rand(0..99) < enemy.luck
      @attack_type.miss_attack(self)
    elsif rand(0..150) < enemy.luck
      @attack_type.critical_attack(self,enemy,damage)
    elsif rand(0..200) < enemy.luck and @mp > 0
      @attack_type.magic_attack(self,enemy)
    else
      @attack_type.normal_attack(self,enemy,damage)
    end
  end

  def check_unit_alive
    if @hp <= 0
      @hp = 0
      'die'
    else
      'alive'
    end
  end
end

class Attack_Type
  def initialize
    @log_print = Print.new
  end
  def normal_attack(me, enemy, damage)
    enemy.hp = enemy.hp - damage
    log=  "#{me.name}은(는) #{enemy.name}에게 #{damage}만큼의 피해를 주었다.\n\n"
    @log_print.console_print(log)
    @log_print.text_print(log)
  end
  def critical_attack(me, enemy, damage)
    enemy.hp = enemy.hp - damage + 9
    log = "Critical Hit! #{me.name}은(는) #{enemy.name}에게 #{damage+9}만큼의 피해를 주었다.\n\n"
    @log_print.console_print(log)
    @log_print.text_print(log)
  end
  def magic_attack(me, enemy)
    enemy.hp = enemy.hp - 20
    me.mp = me.mp  - 10
    log = "Magic Attack!! #{me.name}은(는) #{enemy.name}에게 20만큼의 고정 피해를 주었다.\n\n"
    @log_print.console_print(log)
    @log_print.text_print(log)
  end
  def miss_attack(me)
    log = "#{me.name}의 공격이 빗나갔다!\n\n"
    @log_print.console_print(log)
    @log_print.text_print(log)
  end
end

class Print
  #콘솔 출력 명령
  def console_print(log)
    print log
  end
  #텍스트 파일 출력 명령
  def text_print(log)
    #파일이 존재하지 않을 경우 예외 처리하여 파일을 생성
    begin
      io=open('log.txt',"a")
    rescue
      io=open('log.txt',"w")
    else
      printf(io,log)
      io.close
    end

  end
end

class Battle
  def initialize
    @log_print = Print.new
    @first_attacker = nil
    @round = 0
  end
  def fight(attacker, defender)
    #처음 들어온 attacker가 선공
    if @first_attacker == nil
      @first_attacker = attacker.name
      log = "선공은 #{@first_attacker}입니다.\n"
      @log_print.console_print(log)
      @log_print.text_print(log)
    end
    if @round % 2 == 0
      log = "#{@round/2}번째 턴!!!\n"
      @log_print.console_print(log)
      @log_print.text_print(log)
    end
    attacker.attack(defender)
      if defender.check_unit_alive == 'alive'
        log = "#{defender.name}의 남은 피는 #{defender.hp}입니다. \n\n공격자 변환\n공격자는 #{defender.name}\n\n"
        @log_print.console_print(log)
        @log_print.text_print(log)
        turn_change(attacker,defender)
      else
        log = "#{defender.name}의 피가 0이 되었습니다.\n#{attacker.name}의 승리"
        @log_print.console_print(log)
        @log_print.text_print(log)
        exit false
      end

  end

  def turn_change(attacker,defender)
    attacker,defender = defender, attacker
    @round = @round + 1
    fight(attacker,defender)
  end

end
#처음시작할때 파일이 존재할 경우 새로 만듭니다.
if File.ftype("log.txt")
  io=open('log.txt','w')
end

unit1 =Unit.new("unit1",100,30,20,10,10)
unit1.print_unit_status #랜덤으로 생성된 Unit1의 status를 출력
unit2 =Unit.new("unit2",100,30,20,10,10)
unit2.print_unit_status #랜덤으로 생성된 Unit2의 status를 출력
puts '게임을 진행하시겠습니까? (y/n)'
access = gets.chomp
if access == 'y'
  battle = Battle.new #Battle을 사용하기 위한 Battle 인스턴스 생성
  attacker=[unit1, unit2].shuffle #선공을 랜덤으로 정하기위해 shuffle
  battle.fight(attacker[0], attacker[1])
else
  exit false
end