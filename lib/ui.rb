require_relative '../lib/board'

class Ui
  attr_reader :input, :output

  def initialize(input = $stdin, output = $stdout)
    @input = input
    @output = output
    @board = Board.new(@cells)
  end

  def greet_user
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
    name = input.gets.chomp
    name
  end

  def ask_for_starter
    output.puts "Do you want to start? Please answer with y/n:"
    starting = input.gets.chomp
    starting
  end 

  def ask_for_move
    output.puts "Please choose a free position to make a move:"
    show_game_state 
    move = input.gets.chomp
    move
  end

  def show_game_state
    output.puts "#{@board.cells[0]} | #{@board.cells[1]} | #{@board.cells[2]}"
    output.puts "--|---|--"
    output.puts "#{@board.cells[3]} | #{@board.cells[4]} | #{@board.cells[5]}"
    output.puts "--|---|--"
    output.puts "#{@board.cells[6]} | #{@board.cells[7]} | #{@board.cells[8]}"
  end
end
