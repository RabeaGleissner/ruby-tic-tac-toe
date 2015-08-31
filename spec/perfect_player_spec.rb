require 'board'
require 'perfect_player'
require 'spec_helper'
require 'pry-byebug'

describe PerfectPlayer do
  before do
    @board = Board.new([0,1,2,3,4,5,6,7,8])
  end
  let(:perfect_player) {PerfectPlayer.new('x', @board)}

  it 'places the mark in the middle if there are less than two marks on the board and the centre is free' do
    @board = Board.new(['o',1,2,
                        3,4,5,
                        6,7,8])
    expect(perfect_player.return_move).to eq(4)
  end

  it 'places the mark in the corner on the same edge if there are 7 free positions on the board and the centre is not free' do
    @board = Board.new(['x',1,2,
                        3,'o',5,
                        6,7,8])
    expect(perfect_player.return_move).to eq(6)
  end

  it 'doesn not place the mark in a corner that is already in use' do
    @board = Board.new(['o',1,2,
                        3,'o',5,
                        'x',7,8])
    expect(perfect_player.return_move).to eq(8)
  end

  it 'returns the winning move' do
    @board = Board.new(['x','x','o',
                        'x','o', 5,
                         6,  7 , 8])
    expect(perfect_player.return_move).to eq(6)
  end

  it 'blocks a potential win for the opponent' do
    @board = Board.new(['x','x','o',
                         3,  4, 'o',
                         6,  7,  8 ])
    expect(perfect_player.return_move).to eq(8)
  end

  it 'makes the winning move if possible' do
    @board = Board.new(['x','x','o',
                        'x',  4,  5,
                         6,  'o', 8 ])
    expect(perfect_player.return_move).to eq(6)
  end

  it 'makes the winning move for a diagonal win' do
    @board = Board.new(['x','x','o',
                         3, 'x', 5,
                         6, 'o', 8 ])
    expect(perfect_player.return_move).to eq(8)
  end

  it 'blocks the opponents vertical win' do
    @board = Board.new(['o','o','x',
                         3, 'x', 5,
                        'o', 7, 8 ])
    expect(perfect_player.return_move).to eq(3)
  end

  it 'does not allow opponent to set a trap' do
    @board = Board.new(['o', 1,  2,
                         3, 'x', 5,
                         6,  7, 'o' ])
    expect(perfect_player.return_move).to eq(1)
  end

  it 'returns the winning mark' do
    game_state = horizontal_win
    expect(perfect_player.check_if_won(game_state)).to eq ('x')
  end

  # Tests related to minimax method which is currently not used 
  it 'makes a move and returns the new game state' do 
    game_state = no_win_two_marks
    expect(perfect_player.make_move(game_state, 4, 'x')).to eq (["x", "x", 2, 3, "x", 5, 6, 7, 8])
  end

  it 'assigns the score of 10 if the computer wins' do
    game_state = horizontal_win
    expect(perfect_player.assign_score(game_state, 'x')).to eq(10)
  end

  it 'assigns the score of 0 if it is a draw' do
    game_state = full_board
    expect(perfect_player.assign_score(game_state, 'x')).to eq(0)
  end

  it 'assigns the score of -10 if the computer loses' do
    game_state = diagonal_win_for_o
    expect(perfect_player.assign_score(game_state, 'x')).to eq(-10)
  end

  it 'returns the winning move using mini_max method' do
    @board = Board.new(['x','x','o','x','o', 'o', 6,  7 , 'x'])
    expect(perfect_player.mini_max(['x','x','o','x','o', 'o', 6,  7 , 'x'], 'x', [6,7])).to eq(6)
  end

  it 'returns the winning move using mini_max method with more than two free positions' do
    @board = Board.new(['x','x','o','x','o', 5,6, 7, 'o'])
    expect(perfect_player.mini_max(['x','x','o','x','o', 5, 6, 7, 'o'], 'x', [5,6,7])).to eq(6)
  end
 # end of minimax related tests

  it 'returns true if it is a draw' do 
    game_state = full_board
    expect(perfect_player.check_if_drawn(game_state)).to eq(true)
  end

  it 'returns true if the board is full' do
    game_state = full_board
    expect(perfect_player.board_full?(game_state)).to eq(true)
  end

  it 'returns the corners of the current game state' do 
    @board = Board.new(['o',1,2,
                        3,4,5,
                        'x',7,8])
    expect(perfect_player.corners).to eq(["o", 2, "x", 8])
  end

  it 'returns a hash of corners with positions as values' do 
    @board = Board.new(['o',1,2,
                        3,4,5,
                        'x',7,8])
    expect(perfect_player.corners_hash).to eq({"o"=>0, 2=>2, "x"=>6, 8=>8})
  end

  it 'checks if the position is already taken' do
    @board = Board.new(['o', 1,  2,
                         3, 'x', 5,
                         6,  7, 'o' ])
    expect(perfect_player.is_free?(0)).to eq(false)
  end

  it 'creates a hash of all moves with placeholders for rating' do
    expect(perfect_player.moves_with_rating([1,2,3,4])).to eq({1=>"rating", 2=>"rating", 3=>"rating", 4=>"rating"})
  end

  it 'returns false if there is no winner' do
    expect(perfect_player.check_if_won(['x',1,'o','x','o', 5, 6, 'o', 8])).to eq(false)
  end

  it 'returns the winning mark' do
    expect(perfect_player.check_if_won(['x',1,'o','x','o', 5, 'x', 7 , 8])).to eq('x')
  end

end