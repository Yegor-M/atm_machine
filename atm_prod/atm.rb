require 'yaml'
require 'pry'

def banknote_validate
  sum_of_banknotes = 0
  banknotes = YAML.load_file('machine.yml')
  banknotes = banknotes['banknotes']
  banknotes.each_pair {| key,value |
    sum_of_banknotes = key * value + sum_of_banknotes
    @sum_of_banknotes = sum_of_banknotes.to_i
    }
end

def authorization
  @hash = YAML.load_file('machine.yml')
  @cash = 0
  @check = 0
  @n = 0
  print " -Bank App- \nEnter your account number:"
  @n = gets.chomp.to_i
  print 'Enter your password:'
  password = gets.chomp.to_s
  @balance = @hash['accounts'][@n]["balance"].to_i
  @balance_int = @balance.to_i
  if password == @hash['accounts'][@n]['password']
    registered_user
  else
    wrong_user
  end
end

def registered_user
  banknote_validate
  @user = @hash['accounts'][@n]['user']
  puts "\nHello #{@user}!\nYour balance is #{@balance}$"
  until @check > 0
    if @sum_of_banknotes <= 0
      puts "\nTerminal has no money..."
      return
    end
    puts "\nChoose the action:\n 1. Withdraw\n 2. Logout\n"
    action = gets.to_i
    if action == 1
      withdraw
    elsif action == 2
      logout
    else
      puts 'Unkown command! Try again'
    end
  end
end

def wrong_user
  puts '---Invalid password or account!---'
  return
end

def withdraw
  print 'Enter the sum you want to Withdraw:'
  @cash = gets.to_i
    if @balance_int-@cash < 0
      puts 'Not enough money!'
    elsif @sum_of_banknotes < @cash
      puts "Sorry,this terminal has maximum #{@sum_of_banknotes}$"
    elsif @cash <= 0
      puts "You can't withdraw 0 or less..."
    else
      @sum_of_banknotes -= @cash
      @balance_int -= @cash
      @hash['accounts'][@n]['balance'] = @balance_int
      puts "Now,your balance is #{@balance_int}$"
    end
end

def logout
  File.open('machine.yml', 'w') do |file|
    file.puts @hash.to_yaml
  end
  puts 'Goodbye!!!'
  @check = 1
end

authorization
