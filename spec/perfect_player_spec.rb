require 'board'
require 'perfect_player'
require 'spec_helper'
require 'pry-byebug'

describe PerfectPlayer do
  before do
    @board = Board.new([0,1,2,3,4,5,6,7,8])
  end
  let(:perfect_player) {PerfectPlayer.new('x', @board)}
  
  it 'returns all empty corners' do

  end

  it 'returns a move without having used any corners before' do 
    @board = Board.new([ 'x', 1,  2,
                          3, 'o', 5,
                          6, 'x', 8])
    perfect_player = PerfectPlayer.new('o', @board)
    expect(perfect_player.return_move).to eq(2)
  end

  it 'places o mark to block a trap made by x' do
    @board = Board.new([ 0,  1,  2,
                         3, 'o','x',
                         6, 'x', 8])
    perfect_player = PerfectPlayer.new('o', @board)
    expect(perfect_player.return_move).to eq(6)
  end

  it 'places o mark to block a trap made by x' do
    @board = Board.new([ 0,'x', 2,
                        'x','o', 5,
                         6, 7, 8])
    perfect_player = PerfectPlayer.new('o', @board)
    expect(perfect_player.return_move).to eq(2)
  end

  it 'places o mark to block a trap made by x' do
    @board = Board.new([ 0,'x', 2,
                         3, 'o','x',
                         6, 7, 8])
    perfect_player = PerfectPlayer.new('o', @board)
    expect(perfect_player.return_move).to eq(8)
  end

  it 'does not allow opponent to set a trap' do
    @board = Board.new(['o', 1,  2,
                         3, 'x', 5,
                         6,  7, 'o' ])
    expect(perfect_player.return_move).to eq(1)
  end

  it 'places o mark in a position to deter the trap of x' do
    @board = Board.new(['o',1,2,
                         3,'x',5,
                         6,7,'x'])
    perfect_player = PerfectPlayer.new('o', @board)
    expect(perfect_player.return_move).to eq(6)
  end

  it 'tries to win with only four free spots left if computer is o' do
    @board = Board.new([ 0, 'x', 2,
                         3, 'o', 5,
                        'x','o','x'])
    perfect_player = PerfectPlayer.new('o', @board)
    expect(perfect_player.return_move).to eq(3)
  end

  it 'places the mark next to its own mark if there is a free position on the same line (1)' do
    @board = Board.new(['x', 1, 'o',
                        'o','x','x',
                         6,  7, 'o'])
    expect(perfect_player.return_move).to eq(1)
  end

  it 'places the mark next to its own mark if there is a free position on the same line (2)' do
    @board = Board.new(['x','o','x',
                         3, 'o', 5,
                        'o','x', 8])
    expect(perfect_player.return_move).to eq(5)
  end

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

  it 'returns the corner on the edge that has an empty space in the middle' do
    @board = Board.new(['o', 1,  2,
                         3, 'x', 5,
                         6, 'o','x'])
    expect(perfect_player.same_edge_corner_move).to eq(2)
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

  it 'returns the unused corners' do
    @board = Board.new(['o', 1,  2,
                         3, 'x', 5,
                         6,  7, 'o' ])
    expect(perfect_player.available_corners).to eq([2,6])
  end

end