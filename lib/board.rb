require_relative 'ui'

class Board
  WIN_ARRAYS = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

  attr_accessor :cells

  def initialize
    @cells = (0..8).to_a
  end

  def place_mark(position, mark)
    @cells[position.to_i] = mark
    @cells
  end

  def position_empty?(position)
    available_positions.include? position
  end

  def position_existing?(position)
    @cells.include? position
  end

  def board_full?
    available_positions.length == 0
  end

  def winner(game_state = @cells)
    winner = false
    WIN_ARRAYS.each do |win_array|
      if game_state[win_array[0]] == game_state[win_array[1]]  && game_state[win_array[1]] == game_state[win_array[2]]
        winner = game_state[win_array[0]]
      end
    end
    winner
  end

  def game_over?
    winner != false || board_full?
  end

  def same_marks?(marks)
    marks.all? {|x| x == marks[0]}
  end

  def available_positions
    @cells.find_all do |cell|
      cell.kind_of? Integer
    end
  end

  def switch_mark(mark)
    mark == 'x' ? 'o' : 'x'
  end

  def clear_cells
    cells = []
    @cells.each_with_index do |cell, index|
      cell = index
      cells << cell
    end
    cells
  end

  def mark_at(position)
    @cells[position]
  end

end