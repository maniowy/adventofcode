data = File.read("input.txt").split("\n")

LowerBound = lambda { |r|
  new = r.min+(r.max - r.min)/2
  [(r.min..new), new]
}
UpperBound = lambda { |r|
  new = r.min + ((r.max - r.min)/2.0).round
  [(new..r.max), new]
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
  row = 0
  col = 0
  while !rows.empty? do
    char = rows.slice! 0
    rrange, row = Operators[char].call(rrange)
  end
  while !cols.empty? do
    char = cols.slice! 0
    crange, col = Operators[char].call(crange)
  end  
  highest = [highest, row*8 + col].max
}

puts highest
