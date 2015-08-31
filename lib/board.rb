require_relative 'ui'

class Board
  WIN_ARRAYS = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

  attr_accessor :cells

  def initialize(cells)
    @cells = cells
  end

  def place_mark(position, mark)
    @cells[position.to_i] = mark
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

  def check_if_won(game_state = @cells)
    winner = false
    WIN_ARRAYS.each do |win_array|
      x_counter = 0
      o_counter = 0
      win_array.each do |position|
        if game_state[position] == 'x'
          x_counter += 1
        elsif game_state[position] == 'o'
          o_counter += 1
        end
      end
      if x_counter == 3 
        winner = 'x'
      elsif o_counter == 3
        winner = 'o'
      end
    end
    winner
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

  def switch_mark(mark)
    mark == 'x' ? 'o' : 'x'
  end

end