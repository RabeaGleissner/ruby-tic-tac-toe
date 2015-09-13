require 'spec_helper'
require 'game_flow'
require 'board'
require 'ui'

describe GameFlow do
  let(:output_stream) { StringIO.new }
  let(:input_stream)  { StringIO.new }
  let(:board) {Board.new}
  let(:ui) {Ui.new(board)}
  let(:game_flow) {GameFlow.new(board, ui)}

  before do
  # supressing console output
   $stdout = StringIO.new
  end
  after(:all) do
  # resetting console ouptut
   $stdout = STDOUT
  end

  it 'resets the board' do
    game_flow.reset
    expect(board.cells).to eq [0,1,2,3,4,5,6,7,8] 
  end

  it 'resets the players' do
    game_flow.reset_players
    expect(@starter).to eq nil
  end

  it 'announces the correct outcome of the game (a draw)' do
    board.place_mark(0,'x')
    board.place_mark(1,'o')
    board.place_mark(2,'x')
    board.place_mark(3,'x')
    board.place_mark(4,'o')
    board.place_mark(5,'x')
    board.place_mark(6,'o')
    board.place_mark(7,'x')
    board.place_mark(8,'o')
    game_flow.announce_end_of_game
    # check if correct method was called
  end

  it 'announces the correct outcome of the game (a winner)' do
    board.place_mark(0,'x')
    board.place_mark(1,'x')
    board.place_mark(2,'x')
    game_flow.announce_end_of_game
    # check if correct method was called
  end

  it 'sets up the user' do
    ui.input.stub(:gets) {'y'}
    expect(game_flow.set_up_first_player).to be_an_instance_of User

  end

  it 'sets up the opponent' do
    ui.input.stub(:gets) {'n'}
    expect(game_flow.set_up_second_player).to be_an_instance_of User
  end


end