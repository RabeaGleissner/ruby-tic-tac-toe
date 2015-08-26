RSpec.configure do |config|
    config.color_enabled = true
    config.tty = true
    config.formatter = :documentation
end
def full_board
  board.place_mark(0,'x')
  board.place_mark(1,'o')
  board.place_mark(2,'x')
  board.place_mark(3,'x')
  board.place_mark(4,'o')
  board.place_mark(5,'x')
  board.place_mark(6,'o')
  board.place_mark(7,'x')
  board.place_mark(8,'o')
end

def horizontal_win
  board.place_mark(0,'x')
  board.place_mark(1,'x')
  board.place_mark(2,'x')
end

def vertical_win
  board.place_mark(0,'x')
  board.place_mark(3,'x')
  board.place_mark(6,'x')
end

def diagonal_win
  board.place_mark(0,'x')
  board.place_mark(4,'x')
  board.place_mark(8,'x')
end

def no_win_two_marks
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