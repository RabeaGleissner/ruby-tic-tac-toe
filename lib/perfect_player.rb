class PerfectPlayer
  attr_reader :mark, :board

  def initialize(mark, board)
    @mark = mark
    @board = board
  end

  def return_move
    if @board.board_full? == false && @board.check_if_won == false
      if @board.available_positions.length >= 7
        corner_move
      else
        mini_max
      end
    end
  end

  def method_name
    
  end

  def mini_max
    game_state = @board.cells.clone
    copy_of_available_positions = @board.available_positions
    moves_with_rating = {}
    moves_with_rating = {}
    free_positions_hash = {}

    #turning free positions into a hash of available moves with a placeholder for rating
    copy_of_available_positions.each_with_index { |index, move| moves_with_rating[index] = move}
      # moves_with_rating ={5=>0, 6=>1, 7=>2, 8=>3}
    moves_with_rating.each { |key, value| moves_with_rating[key] = 'rating' }
      # moves_with_rating = {5=>"rating", 6=>"rating", 7=>"rating", 8=>"rating"}
    
    copy_of_available_positions.each_with_index { |index, move| free_positions_hash[index] = move}
      # free_positions_hash = {5=>0, 6=>1, 7=>2, 8=>3}

    #assigning a duplicate of the free_positions_hash at the start of the iteration
    free_positions_hash_dup = free_positions_hash.clone

    moves_with_rating.each do |move, rating|
      #{5=>0,6=>1,7=>2,8=>3}
      mark = @mark

      free_positions_hash_dup.each do |index, value| 
        free_positions_hash_dup[index] = mark
        mark = switch_mark(mark)
      end
      # free_positions_hash_dup =  {5=>"x", 6=>"o", 7=>"x", 8=>"o"}
      # for next iteration need to start with placing 'x' at key 6
      
     # placing the marks in the correct index positions of the game state array
     free_positions_hash_dup.each do |index, mark|
      #["x", "x", "o", "x", "o", 5, 6, 7, 8]
      game_state[index] = mark 
     end
     #game_state1 = ["x", "x", "o", 
                    # "x", "o", "x",
                    # "o", "x", "o"] should be -10
     #game_state2 = ["x", "x", "o",
                   # "x", "o", "o", 
                   # "x", "o", "x"] should be +10
     #game_state3 = ["x", "x", "o",
                   # "x", "o", "x", 
                   # "o", "x", "o"] should be -10
      #game_state4 = ["x", "x", "o",
                    # "x", "o", "o", 
                    # "x", "o", "x"] should be +10
      opponent_mark = switch_mark(@mark)                         
      if check_if_won(game_state) == @mark
        moves_with_rating[move] = 10
      elsif check_if_won(game_state) == opponent_mark
        moves_with_rating[move] = -10
      elsif check_if_drawn(game_state) == true
        moves_with_rating[move] = 0
      end

     # get the first key and the first value of the hash
     first_key = free_positions_hash.keys[0]
     first_value = free_positions_hash.values[0]

     # delete the first key/value pair
     free_positions_hash.delete(first_key)
     # create a new hash out of the array
     new_hash = {first_key => first_value}
     #merge the key value pair into the hash - it will be the last element
     new_free_positions_hash = free_positions_hash.merge(new_hash)

     free_positions_hash_dup = new_free_positions_hash.clone
    end
    # moves_with_rating =  {5=>-10, 6=>10, 7=>-10, 8=>-10}
    move = moves_with_rating.key(10)
    return move
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
    win_arrays = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
    win_arrays.each do |win_array|
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

  def hash_of_free_positions_with_index(free_positions)
    hash = Hash.new
    free_positions.each_with_index do |position, index|
      hash[position] = index
    end
    hash
  end

  def switch_mark(mark)
    if mark == 'x'
      mark = 'o'
    else
      mark = 'x'
    end
  end

  def score
    if @board.board_full? && @board.check_if_won == false
      0
    elsif @board.check_if_won == 'x' || @board.check_if_won == 'o'
      10
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