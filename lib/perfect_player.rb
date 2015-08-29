class PerfectPlayer
  attr_reader :mark, :board

  def initialize(mark, board)
    @mark = mark
    @board = board
  end

  def return_move
    if @board.board_full? == false && @board.check_if_won == false
      if @board.available_positions.length >= 2
        corner_move
      else
        6
      end
    else
      puts "Game over"
    end
  end

  ### Mini-Max ###
  # takes a copy of game state and makes first available move, switches to opponent mark, makes second available move, switches to own mark, makes move etc. - outcome of game will give score to the first move
  # if won, score is 1, if drawn, score is 0, if lost, score is -1
  # takes another copy of the initial game state and starts with second available move, places third available move, then switches mark, places fourth available move - need to go back to the beginning and use first available move last - outcome of game will give score to second move
  # after all options have been played, get first move with score 1 and make it

  def score
    if @board.board_full? && @board.check_if_won == false
      0
    elsif @board.check_if_won == true
      1
    end
  end

  def corner_move
    available_corner_moves = @board.available_positions & corners
    available_corner_moves.first
  end

  def corners
    [0,2,6,8]
  end



end