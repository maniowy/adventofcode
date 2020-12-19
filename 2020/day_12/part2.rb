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
    @position = [0, 0]
    @waypoint = [10, 1]
  end

  def move what, dir, val
    what[0] += dir[0] * val
    what[1] += dir[1] * val
  end

  def rotate side, val
    sign = (side == 'L') ? 1 : -1

    len = Math.sqrt(@waypoint[0]**2 + @waypoint[1]**2)
    current = Math.atan2(@waypoint[1], @waypoint[0])
    angle = sign*(val/90)*Math::PI/2

    cos = (len*Math.cos(current + angle)).round
    sin = (len*Math.sin(current + angle)).round

    @waypoint = [cos, sin]
  end

  private def vectorToWaypoint
    @waypoint.map.with_index{ |x, i| x - @position[i] }
  end

  def getManhattanDistance
    @instructions.each { |i|
      action, value = i
      if %w[R L].include?(action) then
        rotate action, value
      elsif action == 'F' then
        move @position, @waypoint, value
      else
        move @waypoint, @compass[action], value
      end
    }

    @position[0].abs + @position[1].abs
  end
end

puts Navigator.new(data).getManhattanDistance
