require 'spec_helper'
require 'game_flow'
require 'board'
require 'ui'
require 'perfect_player'
require 'pry-byebug'

describe GameFlow do
  let(:output_stream) { StringIO.new }
  let(:input_stream)  { StringIO.new }
  let(:board) {Board.new}
  let(:ui) {Ui.new(board, output_stream, input_stream)}
  let(:game_flow) {GameFlow.new(board, ui)}
  let(:perfect_player) {PerfectPlayer.new('x', board)}

  it 'calls the right method depending on the game option that the user chooses (1)' do
    allow(ui).to receive(:menu).and_return('1')
    expect(game_flow).to receive(:human_vs_computer)
    game_flow.game_options
  end

  it 'calls the right method depending on the game option that the user chooses (2)' do
    allow(ui).to receive(:menu).and_return('2')
    expect(game_flow).to receive(:human_vs_human)
    game_flow.game_options
  end

  it 'calls the right method depending on the game option that the user chooses (3)' do
    allow(ui).to receive(:menu).and_return('3')
    expect(game_flow).to receive(:computer_vs_computer)
    game_flow.game_options
  end

  it 'calls the right method depending on the game option that the user chooses (4)' do
    allow(ui).to receive(:menu).and_return('q')
    expect(Kernel).to receive(:exit)
    game_flow.game_options
  end

  it 'switches over the players' do
    player1 = User.new('name', 'x')
    player2 = User.new('name2', 'o')
    players = [player1, player2]
    expect(game_flow.switch_players(player1, players)).to eq(player2)
  end

  it 'resets the board' do
    game_flow.reset
    expect(board.cells).to eq [0,1,2,3,4,5,6,7,8] 
  end

  it 'resets the players' do
    game_flow.reset_players
    expect(@starter).to eq nil
  end

  it 'announces the correct outcome of the game (a winner)' do
    board.place_mark(0,'x')
    board.place_mark(1,'x')
    board.place_mark(2,'x')
    expect(ui).to receive(:announce_winner)
    game_flow.announce_end_of_game
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
    expect(ui).to receive(:announce_game_drawn)
    game_flow.announce_end_of_game
  end

  it 'sets up the first player as a starter and the second as the opponent' do
    allow(ui.input).to receive(:gets).and_return('y')
    expect(game_flow.set_up_first_player).to be_an_instance_of User
    expect(game_flow.set_up_second_player).to be_an_instance_of User
  end

  it 'sets up the first player as the opponent and the second as the starter' do
    allow(ui.input).to receive(:gets).and_return('n')
    expect(game_flow.set_up_first_player).to be_an_instance_of User
    expect(game_flow.set_up_second_player).to be_an_instance_of User
  end

  it 'returns a computer move' do 
    expect(perfect_player).to receive(:return_move)
    game_flow.get_move(perfect_player)
  end

  it 'returns a human\'s move' do
    player = User.new('name', 'x')
    expect(ui).to receive(:ask_for_move).with(player)
    game_flow.get_move(player)
  end

  it 'returns false if the game has not ended' do
    board.place_mark(0,'x')
    board.place_mark(1,'x')
    expect(game_flow.announce_end_of_game).to eq(false)
  end

  it 'resets the board and shows game options at the end of a game' do
    expect(game_flow).to receive(:reset)
    expect(ui).to receive(:press_enter_to_continue)
    expect(game_flow).to receive(:game_options)
    game_flow.end_of_game_actions
  end


end