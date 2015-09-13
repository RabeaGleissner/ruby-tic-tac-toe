require 'pry-byebug'
require_relative 'ui'
require_relative 'board'
require_relative 'user'
require_relative 'perfect_player'

class GameFlow
  attr_reader :board, :ui

  def initialize(board, ui)
    @board = board
    @ui = ui
  end

  def game_options
    user_choice = @ui.menu
    while user_choice != 'q'
      case user_choice
        when '1' then human_vs_computer
        when '2' then human_vs_human
        when '3' then computer_vs_computer
      end
    end
    Kernel.exit
  end

  def human_vs_human
    set_up_user
    set_up_opponent
    @ui.announce_game_start(@starter, @opponent)
 
    play_human_game
    @ui.show_game_state
    name = winner_name
    mark = @board.winner
    announce_end_of_game
    reset
    @ui.press_enter_to_continue
    game_options
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
    
    if @board.winner
      @ui.announce_winner
    else
      @ui.announce_game_drawn
    end
    @ui.show_game_state
    reset
    @ui.press_enter_to_continue
    game_options
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
      @ui.announce_winner
    else
      @ui.announce_game_drawn
    end
    @ui.show_game_state
    game_options
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
    @ui.ask_for_opponent
    opponent_name = @ui.ask_for_name
    if @starter == nil
      @starter = User.new(opponent_name, 'x')
    else
      @opponent = User.new(opponent_name, 'o')
    end
  end

  def swap_names(name, starter, opponent)
    name == starter ? name = opponent : name = starter
  end

  def announce_end_of_game
    if @board.winner
      return @ui.announce_winner
    elsif @board.board_full?
      return @ui.announce_game_drawn
    else
      return false
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