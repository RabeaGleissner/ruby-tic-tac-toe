class PerfectPlayer

  WIN_ARRAYS = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

  attr_reader :mark, :board

  def initialize(mark, board)
    @mark = mark
    @board = board
    @opponent_mark = @board.switch_mark(@mark)
  end

  def score(game_state)
    if winner(game_state) == @mark
      return 10
    elsif winner(game_state) == @opponent_mark
      return -10
    elsif  game_drawn(game_state)
      return 0
    end
  end

  def return_move_with_minimax(game_state, mark)
    positions = @board.available_positions
    scores = record_scores(game_state, mark)
    hash = Hash[positions.zip scores]

    if hash.key(10)
      return hash.key(10)
    elsif hash.key(0)
      return hash.key(0)
    end
  end

  def assign_scores(game_state, mark)
    if game_over?(game_state)
        score(game_state) 
    else
      scores = possible_game_states(game_state, mark).map do |game_state|
        assign_scores(game_state, switch_mark(mark))
      end
      puts "scores:#{scores}"

      if mark == @mark 
        scores.max
      else
        scores.min
      end
    end
  end

  def record_scores(game_state, mark)
    available_positions(game_state).reduce([]) do |scores, position|
      game_state_dup = game_state.clone
      place_mark(game_state_dup, position, mark)
      scores << assign_scores(game_state_dup, switch_mark(mark))
      scores
    end
  end

  def possible_game_states(game_state, mark)
    available_positions(game_state).reduce([]) do |game_states, position|
      game_state_dup = game_state.clone
      place_mark(game_state_dup, position, mark)
      game_states << game_state_dup
      game_states
    end
  end

### repeat of methods in Board - TODO: remove duplication ###
  def game_drawn(game_state)
    board_full?(game_state) && winner(game_state) == false
  end

  def board_full?(game_state)
    available_positions(game_state).length == 0
  end

  def available_positions(game_state)
    game_state.find_all do |cell|
      cell.kind_of? Integer
    end
  end

  def winner(game_state)
    winner = false
    WIN_ARRAYS.each do |win_array|
      if game_state[win_array[0]] == game_state[win_array[1]]  && game_state[win_array[1]] == game_state[win_array[2]]
        winner = game_state[win_array[0]]
      end
    end
    winner
  end

  def game_over?(game_state)
    winner(game_state) != false || board_full?(game_state)
  end

  def place_mark(game_state, position, mark)
    game_state[position] = mark
    game_state
  end

  def switch_mark(mark)
    mark == 'x' ? 'o' : 'x'
  end
##########################################################
  
  def return_move
    if can_win_or_block(@mark) != false
      return can_win_or_block(@mark)
    end
    if can_win_or_block(@opponent_mark) != false
      return can_win_or_block(@opponent_mark)
    end
    if number_of_free_positions <= 2
      return @board.available_positions.first
    end
    if number_of_free_positions == 4 || number_of_free_positions == 3
     return positions_in_line_with_one_mark(@mark).first
    end
    if centre_free
      return 4
    end
    if number_of_free_positions == 6 && potential_trap != nil
      return potential_trap
    end
    if @mark == 'o'
      moves_when_o
    elsif @mark == 'x'
      moves_when_x
    end
  end

  def moves_when_o
    if number_of_free_positions == 7
      return same_edge_corner_move
    end
    if number_of_free_positions == 6 && computer_uses_corner
      return same_edge_corner_move
    end
    if number_of_free_positions == 6 && computer_uses_corner == false
      return available_corners.first
    end
  end

  def moves_when_x
    if  number_of_free_positions == 7 && opponent_uses_corner != false
      return available_corners.first 
    end
    if number_of_free_positions == 7 && opponent_uses_corner == false || number_of_free_positions == 5
      return same_edge_corner_move
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

  def can_win_or_block(mark)
    can_win_or_block = false
    @board.available_positions.each do |move, rating|
      game_state = @board.cells.clone
      game_state[move] = mark 
      if @board.winner(game_state) != false
         can_win_or_block = move
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