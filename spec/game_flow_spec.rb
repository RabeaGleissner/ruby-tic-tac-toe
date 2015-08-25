require 'spec_helper'
require 'game_flow'
require 'board'

describe GameFlow do
  board = Board.new([0,1,2,3,4,5,6,7,8])
  ui = Ui.new(board)
  let(:game_flow) {GameFlow.new(board, ui)}

  it 'swaps the mark over' do
    expect(game_flow.swap_mark_over('x')).to eq 'o'
  end

  it 'swaps the names over' do
    expect(game_flow.swap_names('joe', 'lisa', 'joe')).to eq 'lisa'
  end

  it 'resets the board' do
    board = Board.new(['x','o','x','o',4,5,6,7,8])
    game_flow.reset
    expect(board.cells).to eq [0,1,2,3,4,5,6,7,8] 
  end

  it 'resets the players' do
    game_flow.reset_players
    expect(@starter).to eq nil
  end


end