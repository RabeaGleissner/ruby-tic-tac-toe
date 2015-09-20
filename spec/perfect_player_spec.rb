require 'spec_helper'
require 'board'
require 'perfect_player'
require 'pry-byebug'

describe PerfectPlayer do
  before do
    @board = Board.new
  end
  let(:perfect_player) {PerfectPlayer.new('x', @board)}

  def set_up_game_state(marks_positions_hash)
    marks_positions_hash.each do |position, mark|
      @board.place_mark(position, mark)
    end
  end

  it 'records the scores for each possible move (1)' do
    # x | 1 | 2
    # --|---|--
    # x | o | x
    # --|---|--
    # 6 | o | o
    set_up_game_state({ 0=>'x', 3=>'x', 4=>'o', 5=>'x', 7=>'o', 8=>'o'})
    expect(perfect_player.score_for_each_possible_move(@board.cells, 'x')).to eq([10,-10,10])
  end

  it 'records the scores for each possible move (2)' do
    # x | o | 2
    # --|---|--
    # o | x | x
    # --|---|--
    # 6 | 7 | o
    set_up_game_state({ 0=>'x', 1=>'o', 3=>'o', 4=>'x', 5=>'x', 8=>'o'})
    expect(perfect_player.score_for_each_possible_move(@board.cells, 'x')).to eq([10,10,0])
  end

  it 'records the scores for each possible move (3)' do
    # x | o | 2
    # --|---|--
    # x | o | 5
    # --|---|--
    # 6 | 7 | 8
    set_up_game_state({ 0=>'x', 1=>'o', 3=>'x', 4=>'o'})
    expect(perfect_player.score_for_each_possible_move(@board.cells, 'x')).to eq([-10,-10,10, 10, -10])
  end

  it 'records the scores for each possible move when there are only two move options (1)' do
    # o | o | x
    # --|---|--
    # x | x | o
    # --|---|--
    # 6 | o | 8
    set_up_game_state({ 0=>'o', 1=>'o', 2=>'x', 3=>'x', 4=>'x', 5=>'o', 7=>'o'})
    expect(perfect_player.score_for_each_possible_move(@board.cells, perfect_player.mark)).to eq([10,0])
  end

  it 'records the scores for each possible move when there are only two move options (2)' do
    # x | o | x
    # --|---|--
    # o | o | 5
    # --|---|--
    # x | x | 8
    set_up_game_state({ 0=>'x', 1=>'o', 2=>'x', 3=>'o', 4=>'o', 6=>'x', 7=>'x'})
    perfect_player = PerfectPlayer.new('o', @board)
    expect(perfect_player.score_for_each_possible_move(@board.cells, perfect_player.mark)).to eq([10,0])
  end

  it 'returns a score when it is passed a final game state' do
    # x | 1 | o
    # --|---|--
    # o | x | o
    # --|---|--
    # 6 | 7 | o
    set_up_game_state({ 0=>'x', 2=>'o', 3=>'o', 4=>'x', 5=>'o', 8=>'o'})
    expect(perfect_player.assign_scores(@board.cells, 'x')).to eq(-10)
  end

  it 'returns all possible game states on the same level' do
    # x | o | 2
    # --|---|--
    # o | x | x
    # --|---|--
    # 6 | 7 | o
    set_up_game_state({ 0=>'x', 1=>'o', 3=>'o', 4=>'x', 5=>'x', 8=>'o'})
    expect(perfect_player.possible_game_states(@board.cells, 'x')).to eq([["x", "o", "x", "o", "x", "x", 6, 7, "o"], ["x", "o", 2, "o", "x", "x", "x", 7, "o"], ["x", "o", 2, "o", "x", "x", 6, "x", "o"]])
  end

  it 'returns moves with minimax' do 
    # x | o | 2
    # --|---|--
    # o | x | x
    # --|---|--
    # 6 | 7 | o
    set_up_game_state({ 0=>'x', 1=>'o', 3=>'o', 4=>'x', 5=>'x', 8=>'o'})
    expect(perfect_player.return_move_with_minimax(@board.cells, 'x')).to eq(2)
  end

  it 'gives a game state a score of 10 if the computer wins' do
    # x | 1 | o
    # --|---|--
    # o | x | 5
    # --|---|--
    # 6 | 7 | x
    set_up_game_state({ 0=>'x', 2=>'o', 3=>'o', 4=>'x', 8=>'x'})
    expect(perfect_player.score(@board.cells)).to eq(10)
  end

  it 'gives a game state a score of -10 if the computer loses' do
    # x | 1 | o
    # --|---|--
    # o | x | o
    # --|---|--
    # 6 | 7 | o
    set_up_game_state({ 0=>'x', 2=>'o', 3=>'o', 4=>'x', 5=>'o', 8=>'o'})
    expect(perfect_player.score(@board.cells)).to eq(-10)
  end

  it 'gives a game state a score of 0 if the game is drawn' do
    # x | x | o
    # --|---|--
    # o | x | x
    # --|---|--
    # x | o | o
    set_up_game_state({ 0=>'x', 1=>'x', 2=>'o', 3=>'o', 4=>'x', 5=>'x', 6=>'x', 7=>'o', 8=>'o'})
    expect(perfect_player.score(@board.cells)).to eq(0)
  end

  it 'returns the a corner on the same edge if there are 2 occupied positions' do
    # o | 1 | 2
    # --|---|--
    # 3 | x | 5
    # --|---|--
    # 6 | 7 | 8
    perfect_player = PerfectPlayer.new('o', @board)
    set_up_game_state({ 0=>'o', 4=>'x'})
    expect(perfect_player.return_move).to eq(6)
  end
  it 'returns the first available corner if there are two free positions ' do
    # o | x | 2
    # --|---|--
    # x | o | 5
    # --|---|--
    # x | o | x
    set_up_game_state({ 0=>'o', 1=>'x', 3=>'x', 4=>'o', 6=>'x', 7=>'o', 8=>'x'})
    expect(perfect_player.return_move).to eq(2)
  end

  it 'returns a corner move on the same edge' do
    # x | o | 2
    # --|---|--
    # o | o | x
    # --|---|--
    # o | x | 8
    set_up_game_state({ 0=>'x', 1=>'o', 3=>'o', 4=>'o', 5=>'x', 6=>'o', 7=>'x'})
    expect(perfect_player.return_move).to eq(2)
  end

  it 'returns 2 to set up a trap' do
  # x | 1 | 2
  # --|---|--
  # o | x | 5
  # --|---|--
  # 6 | 7 | o
    set_up_game_state({ 0=>'x', 3=>'o', 4=>'x', 8=>'o'})
    expect(perfect_player.return_move).to eq(2)
  end
  
  it 'chooses the correct winning move if there are two lines with two equal marks' do
    # 'x', 'o', 'x',
    # 'o', 'o','x',
    # 'x', 7,  8
    marks_positions_hash = { 0 =>'x', 1=>'o', 2=>'x', 3=>'o', 4=>'o', 5=>'x', 6=>'x' }
    set_up_game_state(marks_positions_hash)
    perfect_player = PerfectPlayer.new('o', @board)
    expect(perfect_player.return_move).to eq(7)
  end

  it 'returns all empty corners' do
    #'x', 1,  2,
    # 3, 'o', 5,
    # 6, 'x', 8
    set_up_game_state({ 0=>'x', 4=>'o', 7=>'x' })
    expect(perfect_player.available_corners).to eq([2,6,8])
  end

  it 'returns a move without having used any corners before' do 
    #'x', 1,  2,
    # 3, 'o', 5,
    # 6, 'x', 8
    set_up_game_state({ 0=>'x', 4=>'o', 7=>'x' })
    perfect_player = PerfectPlayer.new('o', @board)
    expect(perfect_player.return_move).to eq(2)
  end

  it 'places o mark to block a trap made by x' do
    # 0,  1,  2,
    # 3, 'o','x',
    # 6, 'x', 8
    set_up_game_state({ 4=>'o', 5=>'x', 7=>'x' })
    perfect_player = PerfectPlayer.new('o', @board)
    expect(perfect_player.return_move).to eq(6)
  end

  it 'places o mark to block a trap made by x' do
    #  0,'x', 2,
    # 'x','o',5,
    #  6, 7, 8
    set_up_game_state({ 1=>'x', 3=>'x', 4=>'o' })
    perfect_player = PerfectPlayer.new('o', @board)
    expect(perfect_player.return_move).to eq(2)
  end

  it 'places o mark to block a trap made by x' do
     # 0,'x', 2,
     # 3,'o','x',
     # 6, 7, 8
    set_up_game_state({ 1=>'x', 4=>'o', 5=>'x' })
    perfect_player = PerfectPlayer.new('o', @board)
    expect(perfect_player.return_move).to eq(8)
  end

  it 'does not allow opponent to set a trap' do
    # 'o', 1,  2,
    #  3, 'x', 5,
    #  6,  7, 'o' 
    set_up_game_state({ 0=>'o', 4=>'x', 8=>'o' })
    expect(perfect_player.return_move).to eq(1)
  end

  it 'places o mark in a position to deter the trap of x' do
    # 'o',1,2,
    #  3,'x',5,
    #  6, 7,'x'
    set_up_game_state({ 0=>'o', 4=>'x', 8=>'x' })
    perfect_player = PerfectPlayer.new('o', @board)
    expect(perfect_player.return_move).to eq(6)
  end

  it 'tries to win with only four free spots left if computer is o' do
    #  0, 'x', 2,
    #  3, 'o', 5,
    # 'x','o','x'
    perfect_player = PerfectPlayer.new('o', @board)
    set_up_game_state({ 1=>'x', 4=>'o', 6=>'x', 7=>'o', 8=>'x' })
    expect(perfect_player.return_move).to eq(3)
  end

  it 'places the mark next to its own mark if there is a free position on the same line (1)' do
    # 'x', 1, 'o',
    # 'o','x','x',
    #  6,  7, 'o'
    set_up_game_state({ 0=>'x', 2=>'o', 3=>'o', 4=>'x', 5=>'x', 8=>'o' })
    expect(perfect_player.return_move).to eq(1)
  end

  it 'places the mark next to its own mark if there is a free position on the same line (2)' do
    # 'x','o','x',
    #  3, 'o', 5,
    # 'o','x', 8
    set_up_game_state({ 0=>'x', 1=>'o', 2=>'x', 4=>'o', 6=>'o', 7=>'x' })
    expect(perfect_player.return_move).to eq(5)
  end

  it 'places the mark in the middle if there are less than two marks on the board and the centre is free' do
    # 'o',1, 2,
    #  3, 4, 5,
    #  6, 7, 8
    set_up_game_state({ 0=>'o'})
    expect(perfect_player.return_move).to eq(4)
  end

  it 'places the mark in the corner on the same edge if there are 7 free positions on the board and the centre is not free' do
    # 'x',1, 2,
    #  3,'o',5,
    #  6, 7, 8
    set_up_game_state({ 0=>'x', 4=>'o' })
    expect(perfect_player.return_move).to eq(6)
  end

  it 'returns the first available corner if there are 7 free positions and the opponent does not use a corner' do 
    set_up_game_state({ 0=>'o', 4=>'x' })
    expect(perfect_player.moves_when_x).to eq(2)
  end

  it 'returns the corner on the edge that has an empty space in the middle (1)' do
    # 'o', 1,  2,
    #  3, 'x', 5,
    #  6, 'o','x'
    set_up_game_state({ 0=>'o', 4=>'x', 7=>'o', 8=>'x' })
    expect(perfect_player.same_edge_corner_move).to eq(2)
  end

  it 'returns the corner on the edge that has an empty space in the middle (2)' do
    # 'x',1, 2,
    #  3,'x','o',
    #  6,'o', 8
    set_up_game_state({ 0=>'x', 4=>'x', 5=>'o', 7=>'o' })
    expect(perfect_player.same_edge_corner_move).to eq(6)
  end

  it 'returns the corner on the edge that has an empty space in the middle (3)' do
    # 0 | 1 | x
    # --|---|--
    # 3 | 4 | 5
    # --|---|--
    # 6 | 7 | 8
    set_up_game_state({ 2=>'x' })
    expect(perfect_player.same_edge_corner_move).to eq(0)
  end

  it 'returns the corner on the edge that has an empty space in the middle (4)' do
    # o | o | x
    # --|---|--
    # 3 | 4 | 5
    # --|---|--
    # 6 | 7 | 8
    set_up_game_state({ 0=>'o', 1=>'o', 2=>'x' })
    expect(perfect_player.same_edge_corner_move).to eq(8)
  end

  it 'returns the winning move' do
    # 'x','x','o',
    # 'x','o', 5,
    #  6,  7 , 8
    set_up_game_state({ 0=>'x', 1=>'x', 2=>'o', 3=>'x', 4=>'o'})
    expect(perfect_player.return_move).to eq(6)
  end

  it 'blocks a potential win for the opponent' do
    # 'x','x','o',
    #  3,  4, 'o',
    #  6,  7,  8 
    set_up_game_state({ 0=>'x', 1=>'x', 2=>'o', 5=>'o'})
    expect(perfect_player.return_move).to eq(8)
  end

  it 'makes the winning move if possible' do
    # 'x','x','o',
    # 'x',  4,  5,
    #  6,  'o', 8
    set_up_game_state({ 0=>'x', 1=>'x', 2=>'o', 3=>'x', 7=>'o'})
    expect(perfect_player.return_move).to eq(6)
  end

  it 'makes the winning move for a diagonal win' do
    # 'x','x','o',
    #  3, 'x', 5,
    #  6, 'o', 8 
    set_up_game_state({ 0=>'x', 1=>'x', 2=>'o', 4=>'x', 7=>'o'})
    expect(perfect_player.return_move).to eq(8)
  end

  it 'blocks the opponents vertical win' do
    # 'o','o','x',
    #  3, 'x', 5,
    #  'o', 7, 8 
    set_up_game_state({ 0=>'o', 1=>'o', 2=>'x', 4=>'x', 6=>'o'})
    expect(perfect_player.return_move).to eq(3)
  end

  it 'returns 0 to fight a potential trap' do
    set_up_game_state({ 7=>'o', 3=>'o'})
    expect(perfect_player.potential_trap).to eq(0)
  end

  it 'returns the corners of the current game state' do 
    # 'o',1,2,
    #  3, 4,5,
    # 'x',7,8
    set_up_game_state({ 0=>'o', 6=>'x'})
    expect(perfect_player.corners).to eq(["o", 2, "x", 8])
  end

  it 'returns a hash of corners with positions as values' do 
    # 'o',1,2,
    #  3, 4,5,
    # 'x',7,8
    set_up_game_state({ 0=>'o', 6=>'x'})
    expect(perfect_player.corners_hash).to eq({"o"=>0, 2=>2, "x"=>6, 8=>8})
  end

  it 'checks if the position is already taken' do
    # 'o', 1,  2,
    #  3, 'x', 5,
    #  6,  7, 'o' 
    set_up_game_state({ 0=>'o', 4=>'x', 8=>'o'})
    expect(perfect_player.is_occupied?(0)).to eq(true)
  end

  it 'returns the unused corners' do
    # 'o', 1,  2,
    #  3, 'x', 5,
    #  6,  7, 'o' 
    set_up_game_state({ 0=>'o', 4=>'x', 8=>'o'})
    expect(perfect_player.available_corners).to eq([2,6])
  end

  it 'returns the first corner that is used by the computer' do
    # 'o', 1, 'x',
    #  3, 'x', 5,
    #  6, 'o', 8
    set_up_game_state({ 0=>'o', 2=>'x', 4=>'x', 7=>'o'})
    expect(perfect_player.corner_used_by_computer).to eq(2)
  end
end