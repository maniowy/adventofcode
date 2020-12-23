Input = ARGV.empty? ? "input.txt" : ARGV.first
cups = File.read(Input).split("").map(&:to_i)

class CupsGame
  attr_reader :cups
  def initialize cups
    @cups = cups
    cups.delete 0
    @currentCup = cups.first
  end

  def move
    pickedUp = (@cups + @cups).slice(@cups.index(@currentCup) + 1, 3)
    @cups.delete_if { |c| pickedUp.include? c }
    destination = getDestinationCup
    @cups.insert(@cups.index(destination) + 1, pickedUp)
    @cups.flatten!
    @currentCup = @cups[(@cups.index(@currentCup)+1) % @cups.size]
  end

  def getDestinationCup
    destination = @currentCup
    loop do
      destination = (destination - 1) % (@cups.max + 1)
      break if @cups.include?(destination)
    end
    destination
  end

  def play count
    1.upto(count).each { |x|
      move
    }
  end

  def result
    indexOfOne = @cups.index 1
    @cups.slice(indexOfOne + 1, @cups.size - indexOfOne - 1) + @cups.slice(0, indexOfOne)
  end
end

game = CupsGame.new(cups)
game.play 100
puts "#{game.result.join}"
