require 'spec_helper'
require 'ui'
require 'user'
require 'stringio'

describe Ui do
  let(:output_stream) { StringIO.new }
  let(:input_stream)  { StringIO.new }
  before do
    @board = Board.new
  end
  let(:ui) {Ui.new(@board, input_stream, output_stream)}

  it 'greets the user and gives options' do
    allow(ui.input).to receive(:gets).and_return('2')
    ui.menu
    output_stream.seek(0)
    expect(output_stream.read).to eq "::: WELCOME TO TIC TAC TOE :::\n\nPlease indicate what you would like to do:\n\n1 - Play against the computer\n2 - Play against another human\n3 - Watch the computer play itself\nq - Quit program\n--> \n"
    expect(ui.menu).to eq '2'
  end

  it 'asks user for name' do
    allow(ui.input).to receive(:gets).and_return('Jo')
    ui.ask_for_name
    output_stream.seek(0)
    expect(output_stream.read).to eq "Please enter your name:\n"
    expect(ui.ask_for_name).to eq 'Jo'
  end

  it 'asks the user if they want to start' do
    allow(ui.input).to receive(:gets).and_return('y')
    ui.ask_for_starter
    output_stream.seek(0)
    expect(output_stream.read).to eq "Do you want to start? Please answer with y/n:\n"
    expect(ui.ask_for_starter).to eq 'y'
  end

  it 'displays the game state' do
   ui.show_game_state
   output_stream.seek(0)
   expect(output_stream.read).to eq "0 | 1 | 2\n--|---|--\n3 | 4 | 5\n--|---|--\n6 | 7 | 8\n\n"
  end

  it 'asks the user to make a move' do
    allow(ui.input).to receive(:gets).and_return('4')
    user = User.new("Max", 'o')
    ui.ask_for_move(user)
    output_stream.seek(0)
    expect(output_stream.read).to eq "Max, please choose a free position to make a move:\n\n"
    expect(ui.ask_for_move(user)).to eq 4
  end

  it 'returns the user\'s selected position' do
    user = User.new('Jo', 'o')
    expect(ui.users_selected_position(1, user)).to eq 1
  end

  it 'says that the game is over, if the board is full' do
    full_board
    user = User.new('Jo', 'o')
    ui.users_selected_position(1, user)
    output_stream.seek(0)
    expect(output_stream.read).to eq "It's a draw! Game over.\n"
  end

  it 'asks the user to press enter to continue' do
    ui.press_enter_to_continue
    output_stream.seek(0)
    expect(output_stream.read).to eq "\nPlease press enter to continue. \n\n" 
    allow(ui.input).to receive(:gets)
  end

  it 'announces the winner' do
    horizontal_win
    ui.announce_winner
    output_stream.seek(0)
    expect(output_stream.read).to eq "\nGame over... x has won the match.\n"
  end

  it 'announces that the game is drawn' do
    ui.announce_game_drawn
    output_stream.seek(0)
    expect(output_stream.read).to eq "\nGame over... It's a draw!\n"
  end

  it 'announces the game start' do
    starter = User.new('Jo', 'x')
    opponent = User.new('Max', 'o')
    ui.announce_game_start(starter, opponent)
    output_stream.seek(0)
    expect(output_stream.read).to eq "\Thanks! Jo is x and Max is o. Jo will start.\n"
  end

end
