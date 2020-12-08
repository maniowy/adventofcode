Input = File.read("input.txt").split("\n")
Length = Input[0].length

Slopes = [[1,1], [3,1], [5,1], [7,1], [1,2]]
counts = []

Slopes.each { |slope|
  right = slope[0]
  down = slope[1]

  i = down
  index = 0
  count = 0

  while i < Input.size do
    index = (index + right)%Length
    count += 1 if Input[i][index] == '#'
    i += down
  end

  counts.push count
}

puts counts.reduce(:*)
