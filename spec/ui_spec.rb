require 'ui'
require 'stringio'
require 'spec_helper'
require 'pry-byebug'

describe Ui do
  let(:output_stream) { StringIO.new }
  let(:input_stream)  { StringIO.new }
  before do
    @board = Board.new
  end
  let(:ui) {Ui.new(input_stream, output_stream, @board)}

  it 'greets the user and gives options' do
    ui.input.stub(:gets) {'2'}
    ui.menu
    output_stream.seek(0)
    expect(output_stream.read).to eq "::: WELCOME TO TIC TAC TOE :::\n\nPlease indicate what you would like to do:\n\n1 - Play against the computer\n2 - Play against another human\n3 - Watch the computer play itself\nq - Quit program\n--> \n"
    expect(ui.menu).to eq '2'
  end

  it 'asks user for name' do
    ui.input.stub(:gets) {'Jo'}
    ui.ask_for_name
    output_stream.seek(0)
    expect(output_stream.read).to eq "Please enter your name:\n"
    expect(ui.ask_for_name).to eq 'Jo'
  end

  it 'asks the user if they want to start' do
    ui.input.stub(:gets) {'y'}
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
    ui.input.stub(:gets) {'4'}
    user = User.new("Max", 'o')
    ui.ask_for_move(user)
    output_stream.seek(0)
    expect(output_stream.read).to eq "Max, please choose a free position to make a move:\n\n"
    expect(ui.ask_for_move(user)).to eq 4
  end

  it 'returns the user\'s selected position' do
    expect(ui.users_selected_position(1)).to eq 1
  end

  it 'says that the game is over, if the board is full' do
    full_board
    ui.users_selected_position(1)
    output_stream.seek(0)
    expect(output_stream.read).to eq "It's a draw! Game over.\n"
  end

  # TO DO: figure out how to test this. Issue at the moment: infinite loop because input is always 4, so it will call ask_for_move over and over
  # :nocov:
  xit 'asks the user for input again if the position is occupied' do
    no_win_two_marks
    ui.users_selected_position(1)
    output_stream.seek(0)
    ui.input.stub(:gets) {'4'}
    expect(output_stream.read).to eq "Sorry, this position is not available. Please try again.\nPlease choose a free position to make a move:\n\n0 | x | 2\n--|---|--\n3 | 4 | 5\n--|---|--\n6 | 7 | 8\n"
  end
  # :nocov:


end
