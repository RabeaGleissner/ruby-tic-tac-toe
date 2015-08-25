require_relative 'board'

class Ui
  attr_reader :input, :output

  def initialize(input = $stdin, output = $stdout)
    @input = input
    @output = output
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

  def ask_for_move(board, cells)
    output.puts "Please choose a free position to make a move:\n\n"
    show_game_state(cells)
    move = input.gets.chomp.to_i
    if board.position_empty?(move) && board.position_existing?(move)
      return move
    elsif board.board_full?
      puts "It's a draw! Game over."
    else
      puts "Sorry, this position is not available. Please try again."
      ask_for_move(board, cells)
    end
  end

  def show_game_state(cells)
    output.puts "#{cells[0]} | #{cells[1]} | #{cells[2]}"
    output.puts "--|---|--"
    output.puts "#{cells[3]} | #{cells[4]} | #{cells[5]}"
    output.puts "--|---|--"
    output.puts "#{cells[6]} | #{cells[7]} | #{cells[8]}"
  end
end
