class PerfectPlayer

  WIN_ARRAYS = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

  attr_reader :mark, :board

  def initialize(mark, board)
    @mark = mark
    @board = board
    @opponent_mark = @board.switch_mark(@mark)
  end

  def return_move
    if third_in_line_move(@mark) != false
      return third_in_line_move(@mark)
    end
    if third_in_line_move(@opponent_mark) != false
      return third_in_line_move(@opponent_mark)
    end
    if @board.available_positions.length <=2 
      return @board.available_positions.first
    end
    if @board.available_positions.length == 4 || @board.available_positions.length == 3
     return positions_in_line_with_one_mark(@mark).first
    end
    if centre_free
      return 4
    end
    if @board.available_positions.length == 6 && centre_free == false && potential_trap != nil
      return potential_trap
    end
    if @mark == 'o'
      moves_when_o
    elsif @mark == 'x'
      moves_when_x
    end
  end

  def moves_when_o
    if @board.available_positions.length == 7 && centre_free == false
      return same_edge_corner_move
    end
    if @board.available_positions.length == 6 && computer_uses_corner
      return same_edge_corner_move
    end
    if @board.available_positions.length == 6 && computer_uses_corner == false
      return available_corners.first
    end
    if @board.available_positions.length == 4
      return 
    end
  end

  def moves_when_x
    if  @board.available_positions.length == 7 && opponent_uses_corner != false
      return available_corners.first 
    end
    if @board.available_positions.length == 7 && opponent_uses_corner == false || @board.available_positions.length == 5 && opponent_edge_move != false

      return same_edge_corner_move
    end
  end

  def opponent_edge_move
    empty_edge_positions.each do |edge|
      if @board.cells[edge] == @opponent_mark
        return edge
      else
        return false
      end
    end
  end

  def available_corners
    available_corners = []
    corners.each do |cell|
      if cell.kind_of? Integer
        available_corners << cell
      end
    end
    available_corners
  end

  def potential_trap
    if @board.cells[0] == @opponent_mark && @board.cells[8] == @opponent_mark
      return 1
    elsif @board.cells[2] == @opponent_mark && @board.cells[6] == @opponent_mark
      return 1
    elsif @board.cells[7] == @opponent_mark && @board.cells[5] == @opponent_mark
      return 6
    elsif @board.cells[7] == @opponent_mark && @board.cells[3] == @opponent_mark
      return 0
    elsif @board.cells[1] == @opponent_mark && @board.cells[3] == @opponent_mark
      return 2
    elsif @board.cells[1] == @opponent_mark && @board.cells[5] == @opponent_mark
      return 8
    end
  end

  def same_edge_corner_move
    computer_corner = ''
    corners_hash.each do |mark, corner|
      if mark == @mark
        computer_corner = corner
      end
    end
    if computer_corner == 0 && is_free?(3) && is_free?(6) || computer_corner == 8 && is_free?(7) && is_free?(6)
      return 6
    elsif computer_corner == 0 && is_free?(1) && is_free?(2) || computer_corner == 8 && is_free?(5) && is_free?(2)
      return 2
    elsif computer_corner == 2 && is_free?(1) && is_free?(0) || computer_corner == 6 && is_free?(3) && is_free?(0)
      return 0
    elsif computer_corner == 2 && is_free?(5) && is_free?(8) || computer_corner == 6 && is_free?(7) && is_free?(8)
      return 8
    end
  end

  def third_in_line_move(mark)
    third_in_line_move = false
    @board.available_positions.each do |move, rating|
      game_state = @board.cells.clone
      game_state[move] = mark 
      if @board.check_if_won(game_state) != false
         third_in_line_move = move
      end
    end
    third_in_line_move
  end

  def lines_of_current_game_state
    game_state_lines = []
    all_lines = WIN_ARRAYS
    all_lines.each do |line|
     game_state_lines << line.map {|cell| cell = @board.cells[cell]}
    end
    game_state_lines
  end

  def positions_in_line_with_one_mark(mark)
    lines_with_2_free_cells = []
    lines_of_current_game_state.each do |line| 
      free_cells = 0
      line.each do |cell|
        if cell.kind_of? Integer
          free_cells +=1
        end
        if free_cells == 2
          lines_with_2_free_cells << line
        end
      end
    end
    lines_with_2_free_cells.each do |line|
      if line.include? mark
        two_free_positions = line
        two_free_positions.delete(mark)
        return two_free_positions
      end
    end
  end

  def empty_corners
    [0,2,6,8]
  end

  def empty_edge_positions
    [1,3,5,7]
  end

  def corners
    empty_corners.map do |corner|
      @board.cells[corner]
    end
  end

  def corners_hash
    corners_hash = {}
    corners.each_with_index do |corner, index|
      corners_hash[corner] = index
    end
    index = 0
    corners_hash.each do |k, v| 
      corners_hash[k] = empty_corners[index] 
      index +=1
    end
    corners_hash
  end

  def used_corners
    empty_corners.each do |corner|
      if @board.cells[corner] == @opponent_mark
        return corner
      else
        return false
      end
    end
  end

  def opponent_uses_corner
    empty_corners.each do |corner|
      if @board.cells[corner] == @opponent_mark
        return corner
      else
        return false
      end
    end
  end

  def computer_uses_corner
    empty_corners.each do |corner|
      if @board.cells[corner] == @mark
        return corner
      else
        return false
      end
    end
  end

  def centre_free
    @board.cells[4] == 4
  end

  def is_free?(move)
    if @board.cells[move] == 'x' || @board.cells[move] == 'o'
      false
    else 
      true
    end
  end

end