require 'set'

Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n")

class SittingPlan
  attr_reader :seats

  def initialize data
    @seats = data
    @rows = data.size
    @cols = data[0].size
  end

  def print
    @seats.each { |line| puts line }
  end

  def arrangePeople
    while roundup() == true do
      #puts "Rearranged:"
      #print
      #puts
    end
  end

  def countOccupied
    @seats.reduce(0) { |rsum, row|
      rsum + row.each_char.reduce(0) { |csum, col|  csum +  (col == '#' ? 1 : 0) }
    }
  end

  private def countOccupiedSiblings row, col
    x1, y1 = [[row - 1,0].max, [col - 1, 0].max]
    x2, y2 = [[row + 1, @rows - 1].min, [col + 1, @cols - 1].min]

    occupied = 0
    (x1..x2).each { |x|
      (y1..y2).each { |y|
        next if x == row && y == col
        occupied += count(x, y)
      }
    }
    occupied
  end

  private def count row, col
    @seats[row][col] == '#' ? 1 : 0
  end

  private def roundup
    newSeats = clone
    (0..@rows-1).each { |row|
      (0..@cols-1).each { |col|
        occupied = countOccupiedSiblings(row, col)
        if @seats[row][col] == 'L' && occupied == 0 then
          newSeats[row][col] = '#'
        elsif seats[row][col] == '#' && occupied >= 4 then
          newSeats[row][col] = 'L'
        end
      }
    }
    modified = (newSeats != @seats)
    @seats = newSeats
    modified
  end

  private def clone
    Marshal.load(Marshal.dump(@seats))
  end 
end

plan = SittingPlan.new(data)
plan.arrangePeople
puts plan.countOccupied
