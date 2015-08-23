class Board
  WIN_ARRAYS = [[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]

  attr_accessor :cells

  def initialize
    @cells = (0..8).to_a
  end

  def place_mark(position, mark)
    if position_empty?(position)
      @cells[position] = mark
      @cells
    else
      'Sorry, this position is already occupied!'
    end
  end

  def position_empty?(position)
    if @cells[position].kind_of? Integer
      true
    else
      false
    end
  end

  def full?
    @cells.all? { |cell| cell.kind_of? String }
  end

  def check_if_won
    WIN_ARRAYS.each do |win_array|
      if @cells[win_array[0]] == 'x' && @cells[win_array[1]] == 'x' && @cells[win_array[2]] == 'x'
        return true
      end
      if @cells[win_array[0]] == 'o' && @cells[win_array[1]] == 'o' && @cells[win_array[2]] == 'o'
        return true
      end
    end
    false
  end

  def same_marks?(marks)
    marks.all? {|x| x == marks[0]}
  end

end