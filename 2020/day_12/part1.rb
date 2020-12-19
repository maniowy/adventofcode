Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n")

class Instruction
  def initialize action, value
  end
end

class Navigator
  def initialize data
    @instructions = data.map { |r| [r[0], r.slice(1, r.size - 1).to_i] }
    @compass = {
      "E" => [1, 0],
      "W" => [-1, 0],
      "N" => [0, 1],
      "S" => [0, -1]
    }
    @direction = @compass["E"]
    @position = [0, 0]
  end

  def move dir, val
    @position[0] += dir[0] * val
    @position[1] += dir[1] * val
  end

  def rotate side, val
    sign = (side == 'L') ? 1 : -1

    current = Math.atan2(@direction[1], @direction[0])
    angle = sign*(val/90)*Math::PI/2

    cos = Math.cos(current + angle).round
    sin = Math.sin(current + angle).round
    @direction = [cos, sin]
  end

  def getManhattanDistance
    @instructions.each { |i|
      action, value = i
      if %w[R L].include?(action) then
        rotate action, value
      elsif action == 'F' then
        move @direction, value
      else
        move @compass[action], value
      end
    }

    @position[0].abs + @position[1].abs
  end
end

puts Navigator.new(data).getManhattanDistance
