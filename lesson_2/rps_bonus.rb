VALID_CHOICES = {"r"=> "rock", "p"=> "paper", "s"=> "scissors", "l"=> "lizard", "sp"=> "spock"}

def prompt(style, message)
  puts "*** #{message} ***" if style == "title"
  puts "=> #{message}" if style == "input"
  puts "!!! #{message} !!!" if style == "error"
end

def win?(choice1, choice2)
  (choice1 == "rock" && (choice2 == "lizard" || choice2 == "scissors")) ||
  (choice1 == "paper" && (choice2 == "rock" || choice2 == "spock")) ||
  (choice1 == "scissors" && (choice2 == "lizard" || choice2 == "paper")) ||
  (choice1 == "lizard" && (choice2 == "paper" || choice2 == "spock")) ||
  (choice1 == "spock" && (choice2 == "rock" || choice2 == "scissors"))
end

def result(player, computer)
  if win?(player, computer)
    prompt("title", "You Won!")
    return [1, 0]
  elsif win?(computer, player)
    prompt("input", "You Lost.")
    return [0, 1]
  else
    prompt("input", "It's a tie.")
    return [0, 0]
  end
end

prompt("title", "Welcome to Rock Papaer Scissors (Extended...)!")

loop do 
  score = [0, 0]
  n= score.max
  
  prompt("input", "First to 5 wins the game.")

  while n < 5 do
    prompt("input", "Select from:\n") 
    VALID_CHOICES.each{|key, value| puts "#{key} - to select #{value}"}

    user_choice = ""

    loop do
      user_choice = gets.chomp
      if VALID_CHOICES.keys.include?(user_choice.downcase)
        user_choice = VALID_CHOICES[user_choice]
        break
      end
      prompt("error", "Invalid Choice. Please select from:")
      VALID_CHOICES.each{|key, value| puts "#{key} - to select #{value}"}
    end

    computer_choice = VALID_CHOICES.values.sample

    prompt("input", "You chose #{user_choice} and the computer chose #{computer_choice}:")
    increment = result(user_choice, computer_choice)
    score = [score, increment].transpose.map{|x| x.reduce(:+)}
    n = score.max

    prompt("input", "Current score is:\nYou: #{score[0]}\nComputer: #{score[1]}")
  end

  if score[0] == 5
    prompt("title", "Congratulations! you won by #{score[0]} to #{score[1]} games.")
  else
    prompt("title", "Better luck next time! you lost by #{score[0]} to #{score[1]} games.")
  end
  prompt("input", "Would you like to play again? Enter 'y' - for yes")
  again = gets.chomp
  break unless again.downcase == "y"
  end

prompt("title", "Thank you for playing RPS. Good Bye.")