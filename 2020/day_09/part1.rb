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
end

puts Xmas.new(data).findNotMatching(Preamble)
