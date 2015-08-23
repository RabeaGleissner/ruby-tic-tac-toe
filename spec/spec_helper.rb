RSpec.configure do |config|
    config.color_enabled = true
    config.tty = true
    config.formatter = :documentation
end
def full_board
  board.place_mark(0,'x')
  board.place_mark(1,'x')
  board.place_mark(2,'x')
  board.place_mark(3,'x')
  board.place_mark(4,'x')
  board.place_mark(5,'x')
  board.place_mark(6,'x')
  board.place_mark(7,'x')
  board.place_mark(8,'x')
end

def first_row_all_x
  board.place_mark(0,'x')
  board.place_mark(1,'x')
  board.place_mark(2,'x')
end

def first_column_all_x
  board.place_mark(0,'x')
  board.place_mark(4,'x')
  board.place_mark(8,'x')
end

def two_x_in_first_row
  board.place_mark(0,'x')
  board.place_mark(1,'x')
end

def no_winning_positions
  board.place_mark(0,'x')
  board.place_mark(1,'x')
  board.place_mark(2,'o')
  board.place_mark(3,'o')
  board.place_mark(4,'x')
  board.place_mark(8,'o')
end