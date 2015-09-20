class PerfectPlayer

  WIN_ARRAYS = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

  attr_reader :mark, :board

  def initialize(mark, board)
    @mark = mark
    @board = board
    @opponent_mark = @board.switch_mark(@mark)
  end

  def return_move
    return wins_or_blocks if can_win_or_block
    return centre_move if centre_free
    return any_free_position if number_of_free_positions <= 2
    return place_mark_next_to_own_in_line_with_one_mark if number_of_free_positions <= 4
    return deter_potential_trap if potential_trap
    return corner_move
  end

  def corner_move
    return same_edge_corner_move if same_edge_corner_move != nil
    available_corners.first
  end

  def available_corners
    corners.reject do |cell|
      cell == 'x' || cell == 'o'
    end
  end

  def potential_trap
    deter_potential_trap != nil
  end

  def deter_potential_trap
    return 1 if diagonal_trap
    return 6 if bottom_edge[1] == @opponent_mark && 
                right_edge[1] == @opponent_mark
    return 0 if bottom_edge[1] == @opponent_mark && 
                left_edge[1] == @opponent_mark
    return 2 if top_edge[1] == @opponent_mark && 
                left_edge[1] == @opponent_mark
    return 8 if top_edge[1] == @opponent_mark && 
                right_edge[1] == @opponent_mark  
  end

  def same_edge_corner_move
    edges.each do |edge|
    return edge.last if edge.first == @mark && 
        (edge[1] != 'x' && edge[1] != 'o') && 
        (edge[2] != 'x' && edge[2] != 'o')
    return edge.first if edge.last == @mark && 
        (edge[1] != 'x' && edge[1] != 'o') &&
        (edge[0] != 'x' && edge[0] != 'o')  
    end
    nil
  end

  def corner_used_by_computer
    corners_hash.each do |mark, corner|
      return corner if mark == @mark
    end
  end

  def wins_or_blocks
    move = []
    lines_of_current_game_state.each do |line|
      if line_has_two_equal_marks_and_one_free_position(line) && line.include?(@mark)
          move = line.select {|position| position != @mark}
          return move.first
        elsif line_has_two_equal_marks_and_one_free_position(line) && line.include?(@opponent_mark)
          move = line.select {|position| position != @opponent_mark}
          return move.first
      end
    end
  end

  def line_has_two_equal_marks_and_one_free_position(line)
    free_positions_in_a_line(line) == 1 && two_equal_marks_in_line(line)
  end

  def free_positions_in_a_line(line)
    free_positions = 0
    line.each do |position|
      if !(position =='x' || position == 'o')
        free_positions += 1
      end
    end
    free_positions
  end

  def two_equal_marks_in_line(line)
    line[0] == line[1] || 
    line[1] == line[2] || 
    line[0] == line[2] 
  end

  def can_win_or_block
    can_win_or_block = false
    lines_of_current_game_state.each do |line|
      if free_positions_in_a_line(line) == 1 && two_equal_marks_in_line(line)
        can_win_or_block = true
      end
    end
    can_win_or_block
  end

  def lines_of_current_game_state
    game_state_lines = []
    all_lines = WIN_ARRAYS
    all_lines.each do |line|
     game_state_lines << line.map {|cell| cell = @board.cells[cell]}
    end
    game_state_lines
  end

  def place_mark_next_to_own_in_line_with_one_mark
    free_positions_in_line_with_own_mark.first
  end

  def free_positions_in_line_with_own_mark
    lines_with_2_free_cells = []
    lines_of_current_game_state.each do |line| 
      if free_positions_in_a_line(line) == 2
        lines_with_2_free_cells << line
      end
    end
    lines_with_2_free_cells.each do |line|
      if line.include? @mark
        two_free_positions = line
        two_free_positions.delete(@mark)
        return two_free_positions
      end
    end
  end

  def empty_corners
    [0,2,6,8]
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

  def top_edge
    edge = []
    edge << @board.cells[0] << @board.cells[1] << @board.cells[2]
  end

  def left_edge
    edge = []
    edge << @board.cells[0] << @board.cells[3] << @board.cells[6]
  end

  def right_edge
    edge = []
    edge << @board.cells[2] << @board.cells[5] << @board.cells[8]
  end

  def bottom_edge
    edge = []
    edge << @board.cells[6] << @board.cells[7] << @board.cells[8]
  end

  def edges
    edges = []
    edges << top_edge << left_edge << right_edge << bottom_edge
  end

  def centre_move
    4
  end

  def any_free_position
    @board.available_positions.first
  end

  def centre_free
    @board.cells[4] == 4
  end

  def is_occupied?(move)
    @board.cells[move] == 'x' || @board.cells[move] == 'o'
  end

  def number_of_free_positions
    @board.available_positions.length
  end

  def diagonal_trap
    @board.cells[0] == @opponent_mark && @board.cells[8] == @opponent_mark || @board.cells[2] == @opponent_mark && @board.cells[6] == @opponent_mark
  end

end