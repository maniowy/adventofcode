require 'set'
data = File.read("input.txt").split("\n\n")

total = data.reduce(0) { |sum, e|
  r = e.split("\n")
  sum + r.reduce(Set.new(r.first.chars)) { |rsum, re|
    rsum & Set.new(re.chars)
  }.size
}

puts total

