class PerfectPlayer

  WIN_ARRAYS = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

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

  def mini_max
    game_state = @board.cells.clone
    copy_of_available_positions = @board.available_positions.clone
    moves_with_rating = {}
    moves_with_rating = {}
    free_positions_hash = {}

    # turning free positions into a hash of available moves with a placeholder for rating
    copy_of_available_positions.each_with_index { |index, move| moves_with_rating[index] = move}
    moves_with_rating.each { |key, value| moves_with_rating[key] = 'rating' }
    
    copy_of_available_positions.each_with_index { |index, move| free_positions_hash[index] = move}

    # assigning a duplicate of the free_positions_hash at the start of the iteration
    free_positions_hash_dup = free_positions_hash.clone

    moves_with_rating.each do |move, rating|

      mark = @mark

      free_positions_hash_dup.each do |index, value| 
        free_positions_hash_dup[index] = mark
        game_state(free_positions_hash_dup, game_state)
        mark = switch_mark(mark)
      end

      # for next iteration need to start with placing 'x' at key 6
     
     ## TODO: need to incorporate depth - how many marks need to be placed before game is won? ##
     game_state(free_positions_hash_dup, game_state)

      opponent_mark = switch_mark(@mark)
      assign_score(game_state, move, opponent_mark, moves_with_rating)                         

     # get the first key and the first value of the hash
     first_key = free_positions_hash.keys[0]
     first_value = free_positions_hash.values[0]

     # delete the first key/value pair
     free_positions_hash.delete(first_key)
     # create a new hash out of the array
     new_hash = {first_key => first_value}
     # merge the key value pair into the hash - it will be the last element
     new_free_positions_hash = free_positions_hash.merge(new_hash)

     free_positions_hash_dup = new_free_positions_hash.clone
    end
    move = moves_with_rating.key(10)

    # check for all moves with rating 10, if won of them wins straight away
    if moves_with_rating.length > 1 
      mark = @mark
      good_moves = moves_with_rating.delete_if {|move, rating| rating != 10}
      
      # check if any of the good moves could be a win for 'x'
      good_moves.each do |move, rating|
        game_state = @board.cells.clone
        game_state[move] = 'x' 
        if check_if_won(game_state) != false
          return move
        end
      end

      # check if any of the good moves could be a win for 'x'
      good_moves.each do |move, rating|
        game_state = @board.cells.clone
        game_state[move] = 'o' 
        if check_if_won(game_state) != false
          return move
        end
      end

    end
    return move
 end

 def assign_score(game_state, move, opponent_mark, moves_with_rating)
  if check_if_won(game_state) == @mark
    moves_with_rating[move] = 10
  elsif check_if_won(game_state) == opponent_mark
    moves_with_rating[move] = -10
  elsif check_if_drawn(game_state) == true
    moves_with_rating[move] = 0
  end
   
 end

 def game_state(free_positions_hash_dup, game_state)
   free_positions_hash_dup.each do |index, mark|
    game_state[index] = mark 
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

  def corner_move
    available_corner_moves = @board.available_positions & corners
    available_corner_moves.first
  end

  def corners
    [0,2,6,8]
  end

end