Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n")

class MemoryGame

  def initialize startingNumbers
    @spokenNumbers = Hash.new {}
    startingNumbers.each.with_index { |x, i|
      @spokenNumbers[x] = [i+1]
    }
    @lastSpoken = startingNumbers.last
  end

  def play count
    (@spokenNumbers.size + 1).upto(count).each { |i|
      if !(@spokenNumbers.has_key? @lastSpoken) || @spokenNumbers[@lastSpoken].size == 1 then
        @lastSpoken = 0
      else
        ls = @spokenNumbers[@lastSpoken]
        @lastSpoken = (ls[1] - ls[0])
      end

      @spokenNumbers[@lastSpoken] = update i
    }
    @lastSpoken
  end

  def update index
    if !@spokenNumbers.has_key? @lastSpoken then
      @spokenNumbers[@lastSpoken] = [index]
    else
      @spokenNumbers[@lastSpoken].push index
    end
    @spokenNumbers[@lastSpoken].shift if @spokenNumbers[@lastSpoken].size > 2
    @spokenNumbers[@lastSpoken]
  end
end

data.each { |line|
  startingNumbers = line.split(",").map { |x| x.to_i }
  puts MemoryGame.new(startingNumbers).play 2020
  puts MemoryGame.new(startingNumbers).play 30000000
}
