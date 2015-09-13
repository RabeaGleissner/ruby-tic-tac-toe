require_relative 'board'

class Ui
  attr_reader :input, :output, :board

  def initialize(input = $stdin, output = $stdout, board)
    @input = input
    @output = output
    @board = board
  end

  def menu
    output.puts "::: WELCOME TO TIC TAC TOE :::\n\n"
    output.puts "Please indicate what you would like to do:\n\n"
    output.puts "1 - Play against the computer"
    output.puts "2 - Play against another human"
    output.puts "3 - Watch the computer play itself"
    output.puts "q - Quit program"
    output.puts "--> "
    option = input.gets.chomp
    option
  end

  def ask_for_name
    output.puts "Please enter your name:"
    name = input.gets.chomp.to_s.capitalize
    name
  end

  def ask_for_starter
    output.puts "Do you want to start? Please answer with y/n:"
    starting = input.gets.chomp.to_s
    if starting == 'y' || starting == 'n'
      starting 
    else
      ask_for_starter
    end
  end 

  def ask_for_move(user)
    output.puts "#{user.name}, please choose a free position to make a move:\n\n"
    user_choice = input.gets.to_i
    users_selected_position(user_choice, user)
  end

  def users_selected_position(move, user)
    if @board.position_empty?(move) && @board.position_existing?(move)
      return move
    elsif @board.board_full?
      output.puts "It's a draw! Game over."
    else
      output.puts "Sorry, this position is not available. Please try again."
      ask_for_move(user)
    end
  end

  def show_game_state
    output.puts "#{@board.cells[0]} | #{@board.cells[1]} | #{@board.cells[2]}"
    output.puts "--|---|--"
    output.puts "#{@board.cells[3]} | #{@board.cells[4]} | #{@board.cells[5]}"
    output.puts "--|---|--"
    output.puts "#{@board.cells[6]} | #{@board.cells[7]} | #{@board.cells[8]}"
    output.puts "\n"
  end

  def press_enter_to_continue
    output.puts "\nPlease press enter to continue. \n\n" 
    input.gets
  end

  def announce_winner
    output.puts "\nGame over... #{@board.winner} has won the match.\n"
  end

  def announce_game_drawn
    output.puts "\nGame over... It's a draw!\n"
  end

  def announce_game_start(starter, opponent)
    output.puts "Thanks! #{starter.name} is #{starter.mark} and #{opponent.name} is #{opponent.mark}. #{starter.name} will start."
  end

  def ask_for_opponent
    output.puts "\nNow for the opponent."
  end

end
