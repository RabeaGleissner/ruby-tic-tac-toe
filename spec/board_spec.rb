require 'board'
require 'spec_helper'
require 'pry-byebug'


describe Board do
  let(:board) {Board.new}

  it 'creates an empty board' do 
    expect(board.cells).to eq([0,1,2,3,4,5,6,7,8])
  end

  it 'it places a given mark on the board' do
    expect(board.place_mark(0, 'x')).to eq(['x',1,2,3,4,5,6,7,8])
    expect(board.place_mark(2, 'o')). to eq(['x',1,'o',3,4,5,6,7,8])
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

  it 'knows that the board is not full' do
    expect(board.full?).to eq(false)
  end

  it 'knows that the board is full' do
    full_board
    expect(board.full?).to eq(true)
  end

  it 'understands that the game is won' do
    first_row_all_x
    expect(board.check_if_won). to eq(true)
  end

  it 'understands that the game is won' do
    first_column_all_x
    expect(board.check_if_won).to eq(true)
  end

  it 'understands that the game is not won' do
    two_x_in_first_row
    expect(board.check_if_won).to eq(false)
  end

  it 'understands that the game is not won' do
    no_winning_positions
    expect(board.check_if_won).to eq(false)
  end

  it 'checks if all marks in the array are the same' do
    expect(board.same_marks?(['x','x','x'])).to eq(true)
    expect(board.same_marks?(['x','o','x'])).to eq(false)
  end

end