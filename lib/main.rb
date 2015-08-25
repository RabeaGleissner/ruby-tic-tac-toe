require 'pry-byebug'
require_relative 'game_flow'

board = Board.new([0,1,2,3,4,5,6,7,8])
ui = Ui.new
game_flow = GameFlow.new(board, ui)


response = ui.menu
while response != 'q'
  case response
  when '1' then human_vs_computer
  when '2' then game_flow.human_vs_human
  when '3' then computer_vs_computer
  end
  response = ui.menu
end

