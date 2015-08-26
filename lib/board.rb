require_relative 'ui'

class Board
  WIN_ARRAYS = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

  attr_accessor :cells

  def initialize(cells)
    @cells = cells
  end

  def place_mark(position, mark)
    @cells[position] = mark
    @cells
  end

  def position_empty?(position)
    if @cells[position].kind_of? Integer
      true
    else
      false
    end
  end

  def position_existing?(position)
    if position >= 0 && position <= 8
      true
    else
      false
    end
  end

  def board_full?
    @cells.all? { |cell| cell.kind_of? String }
  end

  def check_if_won
    WIN_ARRAYS.each do |win_array|
      x_counter = 0
      o_counter = 0
      win_array.each do |position|
        if @cells[position] == 'x'
          x_counter += 1
        elsif @cells[position] == 'o'
          o_counter += 1
        end
      end
      if x_counter == 3 || o_counter == 3
        return true
      end
    end
    false
  end

  def game_over?
    if check_if_won || board_full?
      true
    else
      false
    end
  end

  def same_marks?(marks)
    marks.all? {|x| x == marks[0]}
  end

  def available_positions
    @cells.find_all do |cell|
      cell.kind_of? Integer
    end
  end

end