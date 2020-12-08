require 'set'

class Parser
  def initialize(input)
    @accumulator = 0
    @index = 0
    @visited = Set.new
    @commands = input
  end

  def run
    while @index < @commands.size do
      op, arg = @commands[@index].scan(/(nop|acc|jmp) ([+-]\d+)/)[0]

      begin
        self.send(op, arg.to_i)
        @visited.add @index
      rescue
        break
      end
    end
    @accumulator
  end

  def acc (x)
    @accumulator += x
    @index += 1
  end

  def nop (x)
    @index += 1
  end

  def jmp (x)
    @index += x
    raise "loop" if @visited.include? @index
  end
end

Program = File.read("input.txt").split("\n")
puts Parser.new(Program).run
