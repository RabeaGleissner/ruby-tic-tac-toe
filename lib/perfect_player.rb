class PerfectPlayer

  WIN_ARRAYS = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

  attr_reader :mark, :board

  def initialize(mark, board)
    @mark = mark
    @board = board
  end

  def return_move
    if @board.board_full? == false && @board.check_if_won == false
      if @board.available_positions.length >= 8
        corner_move
      elsif winning_positions('x') != false
        winning_positions('x')
      elsif winning_positions('o') != false
        winning_positions('o')
      else
        mini_max(@board.cells.clone, @mark)
      end
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

  def mini_max(game_state, mark, available_positions)
    if check_if_drawn(game_state) == true || check_if_won(game_state) != false 
      return assign_score(game_state, mark) 
    end  
    moves_with_rating = {}
    available_positions(game_state).each do |move|
      new_game_state = make_move(game_state, move, mark)
      moves_with_rating[move] = mini_max(new_game_state, mark, available_positions)
      puts moves_with_rating
      # TO DO: fix bug - in second iteration, mini_max method returns previous move which is assigned as a rating
      mark = switch_mark(mark)
      clear_game_state
    end
    moves_with_rating.key(10)
  end

  def available_positions(game_state)
   game_state.find_all do |cell|
      cell.kind_of? Integer
    end
  end

  def clear_game_state
    @board.cells.clone
  end

  def moves_with_rating(available_positions)
    hash = Hash.new
    available_positions.each_with_index do |position, index|
      hash[position] = "rating"
    end
    hash
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

  # def hash_of_free_positions_with_index(free_positions)
  #   hash = Hash.new
  #   free_positions.each_with_index do |position, index|
  #     hash[position] = index
  #   end
  #   hash
  # end

  def switch_mark(mark)
    if mark == 'x'
      mark = 'o'
    else
      mark = 'x'
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