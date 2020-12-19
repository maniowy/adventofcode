require 'set'

Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n").map(&:to_i)

data.push(0)
data.sort!
data.push(data.max + 3)

def groupBranches data
  arr = [-1]
  data.each_cons(2).with_index { |(x,y), i|
    arr.push i if y - x == 3
  }
  groups = []
  arr.each_cons(2) { |x,y|
    groups.push data.slice(x+1..y)
  }
  groups.filter { |g| g.size > 1 }.map { |a| a.count - 1 }.tally
end

def allCombinations arr, n
  return arr.combination(1).to_a if n == 1
  arr.combination(n) + allCombinations(arr, n - 1)
end

def inRange arr, maxdiff
  arr.each_cons(2) { |x, y|
    if (y - x) > maxdiff then
      return false
    end
  }
  true
end

def generatePossibleArrangements arr, maxdiff
  prev = arr.first - 1
  result = allCombinations(arr, arr.size).filter { |x|
    (x.include? arr.last) && inRange([prev] + x, maxdiff)
  }
end

puts groupBranches(data).to_a.reduce(1) { |sum, (key, value)|
  sum * (generatePossibleArrangements(1.upto(key).to_a, 3).count ** value)
}
