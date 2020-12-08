input = File.read("input.txt").split("\n")
length = input.shift.length

index = 0
count = 0
input.each { |line| 
  index = (index + 3)%length
  count += 1 if line[index] == '#'
}

puts count
