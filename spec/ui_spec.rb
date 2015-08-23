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
    ui.greet_user
    output_stream.seek(0)
    expect(output_stream.read). to eq "::: WELCOME TO TIC TAC TOE :::\n\nPlease indicate what you would like to do:\n\n1 - Play against the computer\n2 - Play against another human\n3 - Watch the computer play itself\nq - Quit program\n--> \n"
    expect(ui.greet_user).to eq '2'
  end

  it 'asks user for name' do
    ui.input.stub(:gets) {'Jo'}
    ui.ask_for_name
    output_stream.seek(0)
    expect(output_stream.read). to eq "Please enter your name:\n"
    expect(ui.ask_for_name).to eq 'Jo'
  end

  it 'asks the user if they want to start' do
    ui.input.stub(:gets) {'y'}
    ui.ask_for_starter
    output_stream.seek(0)
    expect(output_stream.read). to eq "Do you want to start? Please answer with y/n:\n"
    expect(ui.ask_for_starter).to eq 'y'
  end
end
