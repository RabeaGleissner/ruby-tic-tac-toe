class Ui
  attr_reader :input, :output

  def initialize(input = $stdin, output = $stdout)
    @input = input
    @output = output
  end

  def greet_user
    output.puts "::: WELCOME TO TIC TAC TOE :::\n\n"
    output.puts "Please indicate what you would like to do:\n\n"
    output.puts "1 - Play against the computer"
    output.puts "2 - Play against another human"
    output.puts "3 - Watch the computer play itself"
    output.puts "q - Quit program"
    output.puts "--> "
    option = input.gets.chomp
    option
  end

  def ask_for_name
    output.puts "Please enter your name:"
    name = input.gets.chomp
    name
  end

  def ask_for_starter
    output.puts "Do you want to start? Please answer with y/n:"
    starting = input.gets.chomp
    starting
  end 
end