require 'spec_helper'
require 'game_flow'
require 'board'

describe GameFlow do
  let(:output_stream) { StringIO.new }
  let(:input_stream)  { StringIO.new }
  let(:board) {Board.new}
  let(:ui) {Ui.new(board)}
  let(:game_flow) {GameFlow.new(board, ui, input_stream, output_stream)}
  
  before do
  # supressing console output
   $stdout = StringIO.new
  end
  after(:all) do
  # resetting console ouptut
   $stdout = STDOUT
  end

  it 'swaps the names over' do
    expect(game_flow.swap_names('joe', 'lisa', 'joe')).to eq 'lisa'
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
    game_flow.announce_end_of_game("Jo", "x")
    output_stream.seek(0)
    expect(output_stream.read).to eq "Game over! It's a draw.\n"
  end

  it 'announces the correct outcome of the game (a winner)' do
    board.place_mark(0,'x')
    board.place_mark(1,'x')
    board.place_mark(2,'x')
    game_flow.announce_end_of_game("Jo", "x")
    output_stream.seek(0)
    expect(output_stream.read).to eq "Game over! Jo (player x) has won the game.\n"
  end

  it 'sets up the user' do
    ui.input.stub(:gets) {'y'}
    expect(game_flow.set_up_user).to be_an_instance_of User

  end

  it 'sets up the opponent' do
    ui.input.stub(:gets) {'n'}
    expect(game_flow.set_up_opponent).to be_an_instance_of User
  end


end