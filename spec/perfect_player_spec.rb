require 'perfect_player'
require 'spec_helper'
require 'pry-byebug'

describe PerfectPlayer do
  let(:perfect_player) {PerfectPlayer.new}

  it 'chooses a position to make a move' do 
    expect(perfect_player.return_move).to eq(1)
  end

end