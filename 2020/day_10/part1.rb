Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n").map(&:to_i).sort

differenceCount = {
  1 => 0,
  2 => 0,
  3 => 0
}

data.push(data.last + 3)

last = 0

data.each { |x|
  differenceCount[x - last] += 1 
  last = x
}

puts "#{differenceCount[1]*differenceCount[3]}"
