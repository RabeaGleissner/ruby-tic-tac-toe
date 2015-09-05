# Command line Tic Tac Toe in Ruby

## What it can do
There are three different game play options:

* human vs computer
* human vs human
* computer vs computer

The computer will win where possible and will never lose. The user can choose if they want to start.

## How to run it

From the command line:

  `git clone https://github.com/RabeaGleissner/ruby-tic-tac-toe.git`

  `cd ruby-tic-tac-toe`
  
  `ruby lib/main.rb`
  
## How I created it
I used TDD for most methods. Writing tests first helped me to focus on what I actually wanted to achieve next and later gave me security when I refactored some of my code.

I started creating the Board class and User class because I felt that these were the easiest parts of the project. Then came the Ui and the GameFlow for the human vs human game option. 

Some of the larger methods in the GameFlow class are untested because I couldn't really figure out how to test them or how to break them down in a sensible way and then test each smaller method.

Next I created the PerfectPlayer class which consists of a number of rules for the computer to determine which move to make. Again, I wrote tests first for the methods.

First I used my own experience with the game to create rules. When I had quite a few rules but felt that it probably wasn't complete, I used [this article](https://www.quora.com/Is-there-a-way-to-never-lose-at-Tic-Tac-Toe) on "How to never lose at Tic Tac Toe" to refine the rules. I also just played against the computer lots of times and whenever I came across a bug or felt that the computer could have implemented a better strategy, I wrote a test for the respective game state and then adjusted the code to make it pass.

The last option of computer vs computer game was just a matter of creating two instances of the PerfectPlayer class and then alternately letting them chose moves.


## What I had to learn for this project

### TDD
* How to test console output and mock user input with StringIO
* How to suppress console output

### Minimax algorithm
I had heard about the Minimax algorithm as a way to achieve an unbeatable Tic Tac Toe computer player and read up on it quite a lot. I made two attempts of implementing it but just couldn't really figure it out. 

While I understood the basic principal of the algorithm going through all possible game states and for each move assigning a positive score if it leads to a win, a negative score if it leads to a loss and zero if it leads to a draw, I only managed to run through each game state for each remaining free position in order and assign scores. 

Somehow I couldn't figure out how to play all combinations of moves starting with one available move, then play all combinations starting with the next available move etc. while at the same time keeping the scores for all these in memory.
 
So I scrapped all my code for the Minimax algorithm and started again, creating the rules in the way described above.

## What to do next

### Sinatra framework
I would like to move this code into Sinatra and then create a front-end for it and deploy it online.

### Minimax
I want to take some more time and look at more examples of implementations of this algorithm. I would really like to understand it and use it in my code.