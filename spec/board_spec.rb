require 'board'
require 'spec_helper'


describe Board do
  let(:board) {Board.new}

  it 'creates an empty board' do 
    expect(board.cells).to eq([1,2,3,4,5,6,7,8,9])
  end

  it 'given a mark and position, it places it on the board' do
    expect(board.place_mark(1, 'x')).to eq(['x',2,3,4,5,6,7,8,9])
    expect(board.place_mark(3, 'o')). to eq(['x',2,'o',4,5,6,7,8,9])
  end

  it 'checks if a position is empty' do
    expect(board.position_empty?(2)).to eq true
    board.place_mark(2, 'x')
    expect(board.position_empty?(2)).to eq false
  end

  it 'shows an error message if it tries to place a mark in an occpuied position' do
    board.place_mark(2, 'x')
    expect(board.place_mark(2, 'o')). to eq('Sorry, this position is already occupied!')
  end
end