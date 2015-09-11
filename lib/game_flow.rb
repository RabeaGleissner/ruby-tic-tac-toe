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
    name = winner_name
    mark = @board.winner
    announce_end_of_game(name, mark)
    reset
    output.puts "\nPlease press enter to continue. \n\n"
    gets
  end
  
  def winner_name
    if @board.winner == @starter.mark
      return @starter.name
    else
      return @opponent.name
    end
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

    if starter == 'user'
      until @board.game_over?
        position = @ui.ask_for_move
        @board.place_mark(position, @user.mark)
        @ui.show_game_state
        if @board.game_over? == false
          computer_position = @computer.return_move
          @board.place_mark(computer_position, @computer.mark)
        end
      end
    else
      until @board.game_over?
        computer_position = @computer.return_move
        @board.place_mark(computer_position, @computer.mark)
        if @board.game_over? == false
          position = @ui.ask_for_move
          @board.place_mark(position, @user.mark)
          @ui.show_game_state
        end
      end
    end
    
    if @board.winner == 'x' || @board.winner == 'o'
      output.puts "\nGame over... #{@board.winner} has won the match.\n"
    else
      output.puts "\nGame over... It's a draw!\n"
    end
    @ui.show_game_state
    reset
    output.puts "\nPlease press enter to continue. \n\n"
    input.gets
  end

  def computer_vs_computer
    @computer1 = PerfectPlayer.new('x', @board)
    @computer2 = PerfectPlayer.new('o', @board)
    until @board.game_over?
      computer_position1 = @computer1.return_move
      @board.place_mark(computer_position1, @computer1.mark)
      @ui.show_game_state
      if @board.game_over? == false
        computer_position2 = @computer2.return_move
        @board.place_mark(computer_position2, @computer2.mark)
        @ui.show_game_state
      end
    end
    if @board.winner == 'x' || @board.winner == 'o'
      output.puts "\nGame over... #{@board.winner} has won the match.\n"
    else
      output.puts "\nGame over... It's a draw!\n"
    end
    @ui.show_game_state
    reset
  end

  def play_human_game
    mark = @starter.mark
    name = @starter.name
    until @board.game_over?
      users_position = @ui.ask_for_move
      @board.place_mark(users_position, mark)
      mark = @board.switch_mark(mark)
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

  def swap_names(name, starter, opponent)
    if name == starter
      name = opponent
    else
      name = starter
    end
    name
  end

  def announce_end_of_game(name, mark)
    if @board.winner
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