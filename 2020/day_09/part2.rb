Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n").map(&:to_i)

Preamble = ARGV.size > 1 ? ARGV[1].to_i : 25

class Xmas
  def initialize(input)
    @input = input
  end

  def findNotMatching(preamble)
    @input.each_cons(preamble+1) { |arr|
      last = arr[preamble]
      last25 = arr.slice(0, preamble)
      lastX, y = nil
      last25.each { |x|
        lastX = x
        y = last - x if (last25 - [x]).include? last - x
        break if y
      }
      return last if !y
    }
  end

  def findContiguousRange(target)
    @input.each_index { |left|
      (left..@input.size - 1).each { |right|
        slice = @input.slice(left..right)
        result = slice.reduce(:+)
        return slice if result == target
        break if result > target
      }
    }
    nil
  end
end

xmas = Xmas.new(data)
range = xmas.findContiguousRange(xmas.findNotMatching(Preamble))
puts "#{range.min+range.max}"
