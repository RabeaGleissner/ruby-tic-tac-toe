require 'board'
require 'spec_helper'


describe Board do
  it 'creates an empty board' do 
    board = Board.new
    expect(board.create_board).to eq([1,2,3,4,5,6,7,8,9])
  end
end