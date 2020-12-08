require 'set'
data = File.read("input.txt").split("\n\n")

total = data.reduce(0) { |sum, e|
  sum + Set.new(e.tr("\n","").chars).size
}

puts total

