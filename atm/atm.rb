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

hash = YAML.load_file('machine.yml')
a = Hash
cash = 0
check = 0
#binding.pry
banknote_validate
print " -Bank App- \nEnter your account number:"
a = gets.chomp.to_i
print "Enter your password:"
user = hash['accounts'][a]["user"]
true_password = hash['accounts'][a]["password"]
balance = hash['accounts'][a]["balance"].to_s
balance_int = balance.to_i
password = gets.chomp.to_s
if password == true_password
  puts "\nHello #{user}!\nYour balance is #{balance}$"
  until check > 0
    puts hash
    if @sum_of_banknotes == 0
      puts "\nTerminal has no money..."
    end
    puts "\nChoose the action:\n 1. Withdraw\n 2. Logout\n"
    action = gets.to_i
    if action == 1
      print "Enter the sum you want to Withdraw:"
      cash = gets.to_i
        if balance_int-cash < 0
          puts "Not enough money!"
          sleep 2
        elsif @sum_of_banknotes < cash
          puts "Sorry,this terminal has maximum #{@sum_of_banknotes}$"
          sleep 2
        elsif cash <= 0
          puts "You can't withdraw 0 or less..."
          sleep 2
        else
          @sum_of_banknotes = @sum_of_banknotes - cash
          balance_int = balance_int - cash
          hash['accounts'][a]["balance"] = balance_int
          puts "Now,your balance is #{balance_int}$"
        end
    elsif action == 2
      File.open("machine.yml", "w") do |file|
        file.puts hash.to_yaml
      end
      puts "Goodbye!!!"
      check = check + 1
    else
      puts "Unkown command! Try again"
      sleep 2
    end
  end
else
  puts "---Invalid password or account!---"
  return
end
