require 'pry-byebug'
require_relative 'ui'
require_relative 'board'
require_relative 'user'

class GameFlow

  def human_vs_human(ui, board)
    name = ui.ask_for_name
    if ui.ask_for_starter == 'y'
      @starter = User.new(name, 'x')
    else
      @opponent = User.new(name, 'o')
    end

    puts "\nNow for the opponent."
    opponent_name = ui.ask_for_name
    if @starter == nil
      @starter = User.new(opponent_name, 'x')
    else
      @opponent = User.new(opponent_name, 'o')
    end

    puts "Thanks! #{@starter.name} is #{@starter.mark} and #{@opponent.name} is #{@opponent.mark}. #{@starter.name} will start."

    mark = @starter.mark
    name = @starter.name

    until board.game_over?
      users_position = ui.ask_for_move(board.cells)
      board.place_mark(users_position, mark)
      mark = swap_mark_over(mark)
      name = swap_names(name, @starter.name, @opponent.name)
    end

    ui.show_game_state(board.cells)
    name = swap_names(name, @starter.name, @opponent.name)
    mark = swap_mark_over(mark)
    puts "Game over! #{name} (player #{mark}) has won the game.\nPlease press enter to continue. \n\n"
    reset(board)

    gets
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

  def reset(board)
    reset_board(board)
    reset_players
  end

  def reset_board(board)
    board.cells = [0,1,2,3,4,5,6,7,8]
  end

  def reset_players
    @starter = nil
    @opponent = nil
  end

end