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
    available_corners = []
    corners.each do |cell|
      if cell.kind_of? Integer
        available_corners << cell
      end
    end
    available_corners
  end

  def potential_trap
    deter_potential_trap != nil
  end

  def deter_potential_trap
    if diagonal_trap
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
    if corner_used_by_computer == 0 && !is_occupied?(3) && !is_occupied?(6) || corner_used_by_computer == 8 && !is_occupied?(7) && !is_occupied?(6)
      return 6
    elsif corner_used_by_computer == 0 && !is_occupied?(1) && !is_occupied?(2) || corner_used_by_computer == 8 && !is_occupied?(5) && !is_occupied?(2)
      return 2
    elsif corner_used_by_computer == 2 && !is_occupied?(1) && !is_occupied?(0) || corner_used_by_computer == 6 && !is_occupied?(3) && !is_occupied?(0)
      return 0
    elsif corner_used_by_computer == 2 && !is_occupied?(5) && !is_occupied?(8) || corner_used_by_computer == 6 && !is_occupied?(7) && !is_occupied?(8)
      return 8
    end
  end

  def corner_used_by_computer
    corners_hash.each do |mark, corner|
      if mark == @mark
        return corner
      end
    end
  end

  def wins_or_blocks
    move = []
    lines_of_current_game_state.each do |line|
      if free_positions_in_a_line(line) == 1 && two_equal_marks_in_line(line)
        if line.include?(@mark)
          move = line.select {|position| position != @mark}
          return move.first
        elsif line.include?(@opponent_mark)
          move = line.select {|position| position != @opponent_mark}
          return move.first
        end
      end
    end
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
    positions_in_line_with_own_mark.first
  end

  def positions_in_line_with_own_mark
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