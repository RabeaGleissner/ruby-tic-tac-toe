require 'board'
require 'spec_helper'
require 'pry-byebug'


describe Board do
  before do
    @board = Board.new
  end

  it 'creates an empty board' do 
    expect(@board.cells).to eq([0,1,2,3,4,5,6,7,8])
  end

  it 'it places a given mark on the board' do
    expect(@board.place_mark(0, 'x')).to eq(['x',1,2,3,4,5,6,7,8])
    expect(@board.place_mark(2, 'o')). to eq(['x',1,'o',3,4,5,6,7,8])
  end

  it 'checks if a position is empty' do
    expect(@board.position_empty?(2)).to eq true
    @board.place_mark(2, 'x')
    expect(@board.position_empty?(2)).to eq false
  end

  it 'knows that the board is not full' do
    expect(@board.board_full?).to eq(false)
  end

  it 'knows that the board is full' do
    full_board
    expect(@board.board_full?).to eq(true)
  end

  it 'understands that the game is won' do
    horizontal_win
    expect(@board.winner). to eq('x')
  end

  it 'understands that the game is won' do
    vertical_win
    expect(@board.winner).to eq('x')
  end

  it 'understands that the game is won' do
    diagonal_win
    expect(@board.winner).to eq('x')
  end

  it 'understands that the game is not won' do
    no_win_two_marks
    expect(@board.winner).to eq(false)
  end

  it 'understands that the game is not won' do
    no_winning_positions
    expect(@board.winner).to eq(false)
  end

  it 'checks if all marks in the array are the same' do
    expect(@board.same_marks?(['x','x','x'])).to eq(true)
    expect(@board.same_marks?(['x','o','x'])).to eq(false)
  end

  it 'knows that the game is over (winner)' do
    diagonal_win
    expect(@board.game_over?).to eq(true)
  end

  it 'knows that the game is over (board is full)' do
    full_board
    expect(@board.game_over?).to eq(true)
  end

  it 'knows that the game is not over (only two marks)' do
    no_win_two_marks
    expect(@board.game_over?).to eq(false)
  end

  it 'checks if a position is existing' do
    expect(@board.position_existing?(20)).to eq(false)
  end

  it 'returns all positions that are still free' do
    horizontal_win
    expect(@board.available_positions).to eq([3,4,5,6,7,8])
  end

  it 'swaps the mark over' do
    expect(@board.switch_mark('x')).to eq 'o'
  end

end