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

  def human_vs_computer
    name = @ui.ask_for_name
    if @ui.ask_for_starter == 'y'
      @starter =  User.new(name, 'x')
      @opponent = PerfectPlayer.new('o', @board)
    else
      @starter = User.new(name, 'o')
      @opponent = PerfectPlayer.new('x', @board)
    end
    @players = [@starter, @opponent]
    player = @players[0]
    play_game(player)
    announce_end_of_game
    end_of_game_actions
  end

  def human_vs_human
    set_up_first_player
    set_up_second_player
    @ui.announce_game_start(@starter, @opponent)
    @players = [@starter, @opponent]
    player = @players[0]
    play_game(player)
    announce_end_of_game
    end_of_game_actions
  end
  
  def computer_vs_computer
    @computer1 = PerfectPlayer.new('x', @board)
    @computer2 = PerfectPlayer.new('o', @board)
    @players = [@computer1, @computer2]
    player = @players[0]
    play_game(player)
    announce_end_of_game
    end_of_game_actions
  end

  def play_game(player)
    player = @players[0]
    @ui.show_game_state
    until @board.game_over?
      position = get_move(player)
      @board.place_mark(position, player.mark)
      @ui.show_game_state
      player = switch_players(player)
    end
  end

  def get_move(player)
    if player.is_a? PerfectPlayer
      return player.return_move
    else
      return @ui.ask_for_move(player)
    end
  end

  def set_up_first_player
    name = @ui.ask_for_name
    if @ui.ask_for_starter == 'y'
      @starter = User.new(name, 'x')
    else
      @opponent = User.new(name, 'o')
    end
  end

  def set_up_second_player
    @ui.ask_for_opponent
    opponent_name = @ui.ask_for_name
    if @starter == nil
      @starter = User.new(opponent_name, 'x')
    else
      @opponent = User.new(opponent_name, 'o')
    end
  end

  def switch_players(player)
    player == @players[0] ? player = @players[1] : player = @players[0]
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

  def end_of_game_actions
    reset
    @ui.press_enter_to_continue
    game_options
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