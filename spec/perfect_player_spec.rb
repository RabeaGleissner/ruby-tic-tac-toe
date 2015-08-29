require 'board'
require 'perfect_player'
require 'spec_helper'
require 'pry-byebug'

describe PerfectPlayer do
  before do
    @board = Board.new([0,1,2,3,4,5,6,7,8])
  end
  let(:perfect_player) {PerfectPlayer.new('x', @board)}

  it 'returns a score of 0 if it is a draw' do
    full_board
    expect(perfect_player.score).to eq(0)
  end

  it 'returns a score of 1 if the game is won' do
    vertical_win
    expect(perfect_player.score).to eq(1)
  end

  it ' places the mark in a free corner if there are less than two marks on the board' do
    @board = Board.new(['x',1,'o',
                        3,4,5,
                        6,7,8])
    expect(perfect_player.return_move).to eq(6)
  end



end