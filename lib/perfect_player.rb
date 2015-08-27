class PerfectPlayer
  attr_reader :mark, :board

  def initialize(mark, board)
    @mark = mark
    @board = board
  end

  def return_move
    1
  end

  def score
    if @board.board_full? && @board.check_if_won == false
      0
    elsif @board.check_if_won == true
      1
    end
  end



end