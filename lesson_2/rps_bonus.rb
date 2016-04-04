VALID_CHOICES = { "r" => "rock", "p" => "paper", "s" => "scissors", "l" => "lizard", "sp" => "spock" }.freeze

def prompt(style, message)
  puts "*** #{message} ***\n-------------" if style == "title"
  puts "=> #{message}" if style == "input"
  puts "!!! #{message} !!!" if style == "error"
end

def first_arg_win?(choice1, choice2)
  (choice1 == "rock" && %w(lizard scissors).include?(choice2)) ||
    (choice1 == "paper" && %w(rock spock).include?(choice2)) ||
    (choice1 == "scissors" && %w(lizard paper).include?(choice2)) ||
    (choice1 == "lizard" && %w(paper spock).include?(choice2)) ||
    (choice1 == "spock" && %w(rock scissors).include?(choice2))
end

def result(player, computer)
  if first_arg_win?(player, computer)
    prompt("title", "You Won!")
    return [1, 0]
  elsif first_arg_win?(computer, player)
    prompt("title", "You Lost.")
    return [0, 1]
  else
    prompt("title", "It's a tie.")
    return [0, 0]
  end
end

def print_options
  VALID_CHOICES.each { |key, value| puts "#{key} - to select #{value}" }
end

prompt("title", "Welcome to Rock Papaer Scissors (Extended...)!")

loop do
  score = [0, 0]
  n = score.max

  prompt("input", "First to 5 wins the game.")

  while n < 5
    prompt("input", "Select from:\n")
    print_options

    user_choice = ""

    loop do
      user_choice = gets.chomp
      if VALID_CHOICES.keys.include?(user_choice.downcase)
        user_choice = VALID_CHOICES[user_choice]
        break
      end
      prompt("error", "Invalid Choice. Please select from:")
      print_options
    end

    computer_choice = VALID_CHOICES.values.sample

    prompt("input", "You chose #{user_choice} and the computer chose #{computer_choice}:")
    increment = result(user_choice, computer_choice)
    score = [score, increment].transpose.map { |x| x.reduce(:+) }
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
  break unless again.casecmp("y") == 0
  system("clear")
end

prompt("title", "Thank you for playing RPS. Good Bye.")
