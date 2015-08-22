class Board

  attr_reader :cells

  def initialize
    @cells = (1..9).to_a
  end

  def place_mark(position, mark)
    if position_empty?(position)
      @cells[position-1] = mark
      @cells
    else
      'Sorry, this position is already occupied!'
    end
  end

  def position_empty?(position)
    if @cells[position-1].kind_of? Integer
      true
    else
      false
    end
  end


end