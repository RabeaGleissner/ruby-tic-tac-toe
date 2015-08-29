require 'pry-byebug'
require_relative 'ui'
require_relative 'board'
require_relative 'user'
require_relative 'perfect_player'

class GameFlow
  attr_reader :board, :ui, :input, :output

  def initialize(board, ui, input = $stdin, output = $stdout)
    @board = board
    @ui = ui
    @input = input
    @output = output
  end

  def human_vs_human
    set_up_user
    set_up_opponent

    output.puts "Thanks! #{@starter.name} is #{@starter.mark} and #{@opponent.name} is #{@opponent.mark}. #{@starter.name} will start."

    play_human_game
    @ui.show_game_state
    name = swap_names(name, @starter.name, @opponent.name)
    mark = swap_mark_over(mark)
    announce_end_of_game(name, mark)
    reset
    output.puts "\nPlease press enter to continue. \n\n"
    gets
  end

  def human_vs_computer
    name = @ui.ask_for_name

    if @ui.ask_for_starter == 'y'
      @user = User.new(name, 'x')
      @computer = PerfectPlayer.new('o', @board)
      starter = 'user'
    else
      @user = User.new(name, 'o')
      @computer = PerfectPlayer.new('x', @board)
    end

    until @board.game_over?
      if starter == 'user'
        position = @ui.ask_for_move
        @board.place_mark(position, @user.mark)
        if @board.game_over? == false
          position = @computer.return_move
          @board.place_mark(position, @computer.mark)
        end
      else
        position = @computer.return_move
        @board.place_mark(position, @computer.mark)
        if @board.game_over? == false
          position = @ui.ask_for_move
          @board.place_mark(position, @user.mark)
        end
      end
    end
    @ui.show_game_state
    if @board.check_if_won == 'x' || @board.check_if_won == 'o'
      output.puts "Game over... #{@board.check_if_won} has won the match."
    else
      output.puts "Game over... It's a draw!"
    end
    reset
    output.puts "\nPlease press enter to continue. \n\n"
    input.gets
  end

  def play_human_game
    mark = @starter.mark
    name = @starter.name
    until @board.game_over?
      users_position = @ui.ask_for_move
      @board.place_mark(users_position, mark)
      mark = swap_mark_over(mark)
      name = swap_names(name, @starter.name, @opponent.name)
    end
  end

  def set_up_user
    name = @ui.ask_for_name
    if @ui.ask_for_starter == 'y'
      @starter = User.new(name, 'x')
    else
      @opponent = User.new(name, 'o')
    end
  end

  def set_up_opponent
    output.puts "\nNow for the opponent."
    opponent_name = @ui.ask_for_name
    if @starter == nil
      @starter = User.new(opponent_name, 'x')
    else
      @opponent = User.new(opponent_name, 'o')
    end
  end

  def swap_mark_over(mark)
    if mark == 'x'
      mark = 'o'
    else 
      mark = 'x'
    end
    mark
  end

  def swap_names(name, starter, opponent)
    if name == starter
      name = opponent
    else
      name = starter
    end
    name
  end

  def announce_end_of_game(name, mark)
    if @board.check_if_won
      output.puts "Game over! #{name} (player #{mark}) has won the game."
    elsif @board.board_full?
      output.puts "Game over! It's a draw."
    else
      output.puts "error"
    end
  end

  def reset
    reset_board
    reset_players
  end

  def reset_board
    @board.cells = [0,1,2,3,4,5,6,7,8]
  end

  def reset_players
    @starter = nil
    @opponent = nil
  end

end