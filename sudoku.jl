using JuMP

function getBoard()

  return readdlm("/Users/maxmontgomery/desktop/sudoku-test1.txt", Int)

end

function sudokuSolver(puzzle)

  board = Model()

  # variables
  # x is binary variable representing is 2-dimensional array row, col containing num
  # x == 1 if num is in row, col of board
  @variable(board, x[col = 1:9, row = 1:9, num = 1:9], Bin)

  #### CONSTRAINTS ####

  # set initial board x value is 1 for give cells with given num
  for row = 1:9, col = 1:9
      if puzzle[row, col] != 0
          @constraint(board, x[row, col, puzzle[row, col]] == 1)
      end
  end

  # one number per 3x3 grid
  for row = 1:3:7, col = 1:3:7, num = 1:9
      @constraint(board, sum{x[r, c, num], r = row:row+2, c = col:col+2} == 1)
  end

  # one number per cell
  for row = 1:9, col = 1:9
       @constraint(board, sum{x[row, col, num], num = 1:9} == 1)
   end

  # one number per col
  for row = 1:9
      for num = 1:9
          @constraint(board, sum{x[row, col, num], col = 1:9} == 1)
      end
  end

  # one number per row
  for col = 1:9
      for num = 1:9
          @constraint(board, sum{x[row, col, num], row = 1:9} == 1)
      end
  end

  solve(board)

  # get values of x
  values = getvalue(x)

  # matrix for values of solution
  solution = zeros(Int,9,9)

  # values of x == 1, store num in solution matrix at row, col
  for row = 1:9, col = 1:9, num = 1:9
      if values[row, col, num] == 1
          solution[row, col] = num
      end
  end

  return solution

end

function printBoard(puzzle)
  for row in 1:9
      for col in 1:9
          print("$(puzzle[row, col]) ")
          if col == 3 || col == 6
              print("| ")
          end
      end
      println()
      if row == 3 || row == 6
          println("------+-------+------")
      end
  end
end

puzzle = getBoard()

# Display initial puzzle
println("Initial Board:")
printBoard(puzzle)
println()

solution = sudokuSolver(puzzle)

# Display solution
println("Solved Board:")
printBoard(solution)
