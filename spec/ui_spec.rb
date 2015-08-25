require 'ui'
require 'stringio'
require 'spec_helper'
require 'pry-byebug'

describe Ui do
  let(:output_stream) { StringIO.new }
  let(:input_stream)  { StringIO.new }
  let(:ui) {Ui.new(input_stream, output_stream)}

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
   ui.show_game_state([0,1,2,3,4,5,6,7,8])
   output_stream.seek(0)
   expect(output_stream.read).to eq "0 | 1 | 2\n--|---|--\n3 | 4 | 5\n--|---|--\n6 | 7 | 8\n"
  end

  xit 'asks the user to make a move' do
    ui.input.stub(:gets) {'4'}
    board = Board.new([[0,1,2,3,4,5,6,7,8]])
    cells = [0,1,2,3,4,5,6,7,8]
    ui.ask_for_move(board, cells)
    output_stream.seek(0)
    expect(output_stream.read).to eq "Please choose a free position to make a move:\n\n0 | 1 | 2\n--|---|--\n3 | 4 | 5\n--|---|--\n6 | 7 | 8\n"
    expect(ui.ask_for_move(cells)).to eq 4
  end

end
