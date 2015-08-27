require 'board'
require 'perfect_player'
require 'spec_helper'
require 'pry-byebug'

describe PerfectPlayer do
  before do
    @board = Board.new([0,1,2,3,4,5,6,7,8])
  end
  let(:perfect_player) {PerfectPlayer.new('x', @board)}

  it 'chooses a position to make a move' do 
    expect(perfect_player.return_move).to eq(1)
  end

  it 'returns a score for a move' do
    full_board
    expect(perfect_player.score).to eq(0)
  end



end