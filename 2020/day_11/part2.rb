require 'set'

Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n")

class SittingPlan
  attr_reader :seats

  def initialize data
    @seats = data
    @rows = data.size
    @cols = data[0].size
    @directions = []
    (-1..1).to_a.each { |x|
      (-1..1).to_a.each { |y|
        @directions << [x, y] if x != 0 || y != 0
      }
    }
    @visible = []
    (0..@rows-1).to_a.each { |x|
      row = []
      (0..@cols-1).to_a.each { |y|
        row << getVisibleSeats(x, y)
      }
      @visible << row
    }
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

  private def countOccupiedVisibleSeats row, col
    occupied = 0
    @visible[row][col].each { |x, y|

        occupied += occupied(x, y)
    }
    occupied
  end

  private def getVisibleSeats row, col
    forward = lambda { |a, b| a.map.with_index { |x, i| a[i] + b[i] } }
    nextSeat = lambda { |c, d|
      seat = forward.call(c, d)
      return nil if !seat[0].between?(0, @rows-1) || !seat[1].between?(0, @cols-1)
      seat
    }

    visible = []
    @directions.each { |d|
      lastSeat = [row, col]
      while (lastSeat = nextSeat.call(lastSeat, d)) do
        x,y = lastSeat
        break if @seats[x][y] != '.'
      end
      visible << lastSeat if lastSeat
    }

    visible
  end

  private def occupied row, col
    @seats[row][col] == '#' ? 1 : 0
  end

  private def roundup
    newSeats = clone
    (0..@rows-1).each { |row|
      (0..@cols-1).each { |col|
        occupied = countOccupiedVisibleSeats(row, col)
        if @seats[row][col] == 'L' && occupied == 0 then
          newSeats[row][col] = '#'
        elsif seats[row][col] == '#' && occupied >= 5 then
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
