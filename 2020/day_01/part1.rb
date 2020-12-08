require 'set'

file = File.open("input.txt", "r")
input = []
file.each { |line| input.push line.to_i }

def product2(numbers, targetSum)
  stored = Set.new

  numbers.each { |i|
    j = targetSum - i
    return i * j if stored.include? j
    stored.add(i)
  }
  nil
end

puts product2(input, 2020)
