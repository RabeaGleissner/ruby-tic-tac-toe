require 'board'
require 'perfect_player'
require 'spec_helper'
require 'pry-byebug'

describe PerfectPlayer do
  before do
    @board = Board.new([0,1,2,3,4,5,6,7,8])
  end
  let(:perfect_player) {PerfectPlayer.new('x', @board)}

  it 'places the mark in a free corner if there are less than two marks on the board' do
    @board = Board.new(['x',1,'o',
                        3,4,5,
                        6,7,8])
    expect(perfect_player.return_move).to eq(6)
  end

  it 'returns the winning move' do
    @board = Board.new(['x','x','o',
                        'x','o', 5,
                         6,  7 , 8])
    expect(perfect_player.mini_max).to eq(6)
  end

  it 'blocks a potential win for the opponent' do
    @board = Board.new(['x','x','o',
                         3,  4, 'o',
                         6,  7,  8 ])
    expect(perfect_player.mini_max).to eq(8)
  end

  it 'makes the winning move if possible' do
    @board = Board.new(['x','x','o',
                        'x',  4,  5,
                         6,  'o', 8 ])
    expect(perfect_player.mini_max).to eq(6)
  end


end