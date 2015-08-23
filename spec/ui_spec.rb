require 'ui'
require 'stringio'
require 'spec_helper'
require 'pry-byebug'

describe Ui do
 
  let(:output_stream) { StringIO.new }
  let(:input_stream)  { StringIO.new }
  let(:ui) {Ui.new(input_stream, output_stream)}

  it 'greets the user and gives options' do
    ui.greet_user
    output_stream.seek(0)
    expect(output_stream.read). to eq "::: WELCOME TO TIC TAC TOE :::\n\nPlease indicate what you would like to do:\n\n1 - Play against the computer\n2 - Play against another human\n3 - Watch the computer play itself\nq - Quit program\n--> \n"
  end

end
