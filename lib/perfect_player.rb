class PerfectPlayer

  WIN_ARRAYS = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

  attr_reader :mark, :board

  def initialize(mark, board)
    @mark = mark
    @board = board
  end

  def return_move
    if winning_positions('x') != false
      return winning_positions('x')
    end
    if winning_positions('o') != false
      return winning_positions('o')
    end
    if potential_trap(@mark)
      return 1
    end
    if centre_free
      return 4
    end
    if @mark == 'o'
      if  @board.available_positions.length == 7 && centre_free == false
        return same_edge_corner_move
      end
    elsif @mark == 'x'

      if  @board.available_positions.length == 7 && opponent_uses_corner != false
        return available_corner(opponent_uses_corner) 
      end
      if @board.available_positions.length == 7 && opponent_uses_corner == false ||  @board.available_positions.length == 5 && opponent_edge_move != false
        return same_edge_corner_move
      end
    end
  end

  def opponent_edge_move
    opponent_mark = switch_mark(@mark)
    empty_edge_positions.each do |edge|
      if @board.cells[edge] == opponent_mark
        return edge
      else
        return false
      end
    end
  end

  def available_corner(opponent_uses_corner)
    remaining_corners = empty_corners
    remaining_corners.delete(opponent_uses_corner)
    remaining_corners.first
  end

  def potential_trap(mark)
    opponent_mark = switch_mark(mark)
    if @board.available_positions.length >= 6
      if @board.cells[0] == opponent_mark && @board.cells[8] == opponent_mark
        true
      elsif @board.cells[2] == opponent_mark && @board.cells[6] == opponent_mark
        true
      end
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

  def winning_positions(mark)
    winning_move = false
    copy_of_available_positions = @board.available_positions.clone
    copy_of_available_positions.each do |move, rating|
      game_state = @board.cells.clone
      game_state[move] = mark 
      if check_if_won(game_state) != false
         winning_move = move
      end
    end
    winning_move
  end

  def available_positions(game_state)
   game_state.find_all do |cell|
      cell.kind_of? Integer
    end
  end

  def check_if_drawn(game_state)
    if check_if_won(game_state) == false && board_full?(game_state)
      true
    end
  end

  def board_full?(game_state)
    game_state.all? { |cell| cell.kind_of? String }
  end

  def check_if_won(game_state)
    winner = false
    WIN_ARRAYS.each do |win_array|
       x_counter = 0
       o_counter = 0
       win_array.each do |position|
         if game_state[position] == 'x'
           x_counter += 1
         elsif game_state[position] == 'o'
           o_counter += 1
         end
       end
       if x_counter == 3
         winner = 'x'
       elsif  o_counter == 3
        winner = 'o'
       end
     end
     winner
  end

  def switch_mark(mark)
    if mark == 'x'
      mark = 'o'
    else
      mark = 'x'
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

  def opponent_uses_corner
    opponent_mark = switch_mark(@mark)
    empty_corners.each do |corner|
      if @board.cells[corner] == opponent_mark
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

  def mini_max(game_state, mark, available_positions)
    if check_if_drawn(game_state) == true || check_if_won(game_state) != false 
      return assign_score(game_state, mark) 
    end  
    moves_with_rating = {}
    available_positions(game_state).each do |move|
      new_game_state = make_move(game_state, move, mark)
      moves_with_rating[move] = mini_max(new_game_state, mark, available_positions)
      # puts moves_with_rating
      # TO DO: fix bug - in second iteration, mini_max method returns previous move which is assigned as a rating
      mark = switch_mark(mark)
      clear_game_state
    end
    moves_with_rating.key(10)
  end

  def moves_with_rating(available_positions)
    hash = Hash.new
    available_positions.each_with_index do |position, index|
      hash[position] = "rating"
    end
    hash
  end

   def clear_game_state
     @board.cells.clone
   end

   def make_move(game_state, move, mark)
     game_state[move] = mark
     game_state
   end

  def assign_score(game_state, mark)
     opponent_mark = switch_mark(mark)
     score = 0
     if check_if_won(game_state) == mark
        score = 10 
     elsif check_if_won(game_state) == opponent_mark
        score = -10 
     elsif check_if_drawn(game_state) == true
        score = 0
     end
     score 
  end
  
end