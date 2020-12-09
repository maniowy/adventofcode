Input = ARGV.empty? ? "input.txt" : ARGV[0]
data = File.read(Input).split("\n")

LowerBound = lambda { |r|
  new = r.min+(r.max - r.min)/2
  (r.min..new)
}
UpperBound = lambda { |r|
  new = r.min + ((r.max - r.min)/2.0).round
  (new..r.max)
}

Operators = {
  "F" => LowerBound,
  "B" => UpperBound,
  "L" => LowerBound,
  "R" => UpperBound
}

highest = 0

data.each { |entry|
  rows = entry.slice (0..6)
  cols = entry.slice (7..9)
  rrange = (0..127)
  crange = (0..7)
  while !rows.empty? do
    char = rows.slice! 0
    rrange = Operators[char].call(rrange)
  end
  while !cols.empty? do
    char = cols.slice! 0
    crange = Operators[char].call(crange)
  end  
  highest = [highest, rrange.first*8 + crange.first].max
}

puts highest
