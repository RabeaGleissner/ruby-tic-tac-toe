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
      case user_choice
        when '1' then human_vs_computer
        when '2' then human_vs_human
        when '3' then computer_vs_computer
        when 'q' then Kernel.exit
      end
  end

  def human_vs_computer
    set_up_human_and_computer_players
    play_game
  end

  def human_vs_human
    set_up_first_player
    set_up_second_player
    @ui.announce_game_start(@starter, @opponent)
    play_game
  end
  
  def computer_vs_computer
    @starter = PerfectPlayer.new('x', @board)
    @opponent = PerfectPlayer.new('o', @board)
    play_game
  end

  def play_game
    players = [@starter, @opponent]
    current_player = players[0]
    @ui.show_game_state
    until @board.game_over?
      position = get_move(current_player)
      @board.place_mark(position, current_player.mark)
      @ui.show_game_state
      current_player = switch_players(current_player, players)
    end
    announce_end_of_game
    end_of_game_actions
  end

  def get_move(player)
    if player.is_a? PerfectPlayer
      return player.return_move
    else
      return @ui.ask_for_move(player)
    end
  end

  def set_up_human_and_computer_players
    name = @ui.ask_for_name
    if @ui.ask_for_starter == 'y'
      @starter =  User.new(name, 'x')
      @opponent = PerfectPlayer.new('o', @board)
    else
      @opponent = User.new(name, 'o')
      @starter = PerfectPlayer.new('x', @board)
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

  def switch_players(current_player, players)
    current_player == players[0] ? current_player = players[1] : current_player = players[0]
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
    @board.cells = @board.clear_cells
  end

  def reset_players
    @starter = nil
    @opponent = nil
  end

end