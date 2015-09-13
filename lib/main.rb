require 'pry-byebug'
require_relative 'game_flow'

board = Board.new
ui = Ui.new(board)
game_flow = GameFlow.new(board, ui)

game_flow.game_options