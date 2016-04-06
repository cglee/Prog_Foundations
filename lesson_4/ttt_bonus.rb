WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + #horizontal
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + #vertical
                [[1, 5, 9], [3, 5, 7]].freeze       #diagonal

PLAYER_MARKER = "X".freeze
COMPUTER_MARKER = "O".freeze
LEVEL = {1=> "Easy", 2=> "Medium", 3=> "Hard"}

def prompt(style, message)
  case style
  when "title" then puts "*** #{message} ***\n"+"-"*(8+message.length)
  when "input" then puts "=> #{message}"
  when "error" then puts "!!! #{message} !!!"
  else puts message
  end
end

def joiner(array, delimiter=', ', word='or')
  array[-1] = "#{word} #{array.last}" if array.size > 1
  array.join(delimiter)
end

def initial_board
  new_board = {}
  (1..9).each { |position| new_board[position] = " " }
  new_board
end

def display_board(brd, level)
  puts "You're Marker: #{PLAYER_MARKER}\nComputer Marker: #{COMPUTER_MARKER}\nLevel: #{LEVEL[level]}"
  puts "      |      |      "
  puts "  #{brd[1]}   |  #{brd[2]}   |  #{brd[3]}   "
  puts "______|______|______"
  puts "      |      |      "
  puts "  #{brd[4]}   |  #{brd[5]}   |  #{brd[6]}   "
  puts "______|______|______"
  puts "      |      |      "
  puts "  #{brd[7]}   |  #{brd[8]}   |  #{brd[9]}   "
  puts "      |      |      "
end

def available_squares(brd)
  brd.keys.select { |position| brd[position] == " " }
end

def player_places_piece!(brd)
  prompt('input', "Your move. Choose a square to place #{PLAYER_MARKER} from (#{joiner(available_squares(brd), delimiter=', ', word='or')})")
  chosen_position = ""
  loop do
    chosen_position = gets.chomp.to_i
    break if available_squares(brd).include?(chosen_position)
    prompt('error', "That position is not available. Please select from (#{joiner(available_squares(brd), delimiter=', ', word='or')})")
  end
  brd[chosen_position] = PLAYER_MARKER
end

def computer_places_piece!(brd, level=1)
  case level
  when 1
    random_choice = available_squares(brd).sample
    brd[random_choice] = COMPUTER_MARKER
  when 2
    if player_square_to_win(brd)
      brd[player_square_to_win(brd)] = COMPUTER_MARKER
    else
      random_choice = available_squares(brd).sample
      brd[random_choice] = COMPUTER_MARKER
    end
  when 3
    if computer_square_to_win(brd)
      brd[computer_square_to_win(brd)] = COMPUTER_MARKER
    elsif player_square_to_win(brd)
      brd[player_square_to_win(brd)] = COMPUTER_MARKER
    elsif brd[5] == " "
      brd[5] = COMPUTER_MARKER
    else
      random_choice = available_squares(brd).sample
      brd[random_choice] = COMPUTER_MARKER
    end
  end
end

def places_piece!(turn, brd, level)
  if turn
    player_places_piece!(brd)
  else
    computer_places_piece!(brd, level)
  end
end

def board_full?(brd)
  available_squares(brd).empty?
end

def winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return "Player"
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return "Computer"
    end
  end
  nil
end

def someone_won?(brd)
  !!winner(brd)
end

def player_square_to_win(brd)
  WINNING_LINES.each do |line|
    board_values = brd.values_at(*line)
    if board_values.count(PLAYER_MARKER) == 2 &&
        board_values.count(COMPUTER_MARKER) == 0
      return line[board_values.index(" ")]
    end
  end
  nil
end

def computer_square_to_win(brd)
  WINNING_LINES.each do |line|
    board_values = brd.values_at(*line)
    if board_values.count(COMPUTER_MARKER) == 2 &&
         board_values.count(PLAYER_MARKER) == 0
      return line[board_values.index(" ")]
    end
  end
  nil
end

def game_over?(brd)
  someone_won?(brd) || board_full?(brd)
end

def display_score(hash)
  prompt("input", "Current Score:")
  hash.each { |name, score| puts "#{name}: #{score}\n" }
end

prompt('title', "Welcome to Tic Tac Toe!")

loop do
  prompt("input", "Enter how many games to race to (e.g. '3' for first to 3 rounds wins:")
  number_of_rounds = ""
  loop do
    number_of_rounds = gets.chomp.to_i
    break if number_of_rounds.to_s =~ /[1-9]+/
    prompt("error", "Invalid entry. Choose a whole number greater than 0.")
  end

  prompt("input", "Choose difficulty level:\n- Select 1 for easy\n- Select 2 for medium\n- Select 3 for hard")
  difficulty = ""
  loop do
    difficulty = gets.chomp.to_i
    break if difficulty.to_s =~ /[1-3]/
    prompt("error", "Invalid entry. Choose a number between 1-3.")
  end

  prompt("input", "Would you like to make the first move? (Select 'y' for Yes, 'n' for No.)")
  first_move = ""
  loop do
    first_move = gets.chomp.downcase
    break if %w(y n).include?(first_move)
    prompt("error", "Invalid entry. Choose y for yes or n for no")
  end

  players_turn = true if first_move == "y"
  current_score = { "Player" => 0, "Computer" => 0 }

  while current_score.values.max < number_of_rounds # Main game loop
   
    board = initial_board
    display_board(board, difficulty)
    display_score(current_score)

    loop do # Loop for each round
      places_piece!(players_turn, board, difficulty)
      system('clear')
      display_board(board, difficulty)
      break if game_over?(board)
      players_turn = !players_turn
    end

    if winner(board) == "Player"
      prompt('input', "You Win this round!")
      current_score["Player"] += 1
    elsif winner(board) == "Computer"
      prompt('input', "Computer Wins this round.")
      current_score["Computer"] += 1
    else
      prompt("input", "It's a tie")
    end
  end

  if current_score["Player"] > current_score["Computer"]
    prompt("title", "Congratulations! You won by #{current_score["Player"]} games to #{current_score["Computer"]}")
  else
    prompt("title", "Unlucky. You lost by #{current_score["Computer"]} games to #{current_score["Player"]}")
  end

  prompt("input", "Would you like to play again? (input 'y' - for yes)")
  play_again = gets.chomp
  system('clear')
  break unless play_again.downcase.start_with?('y')
end

prompt("title", "Thanks for playing! Good bye.")
