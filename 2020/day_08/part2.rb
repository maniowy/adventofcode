require 'set'

class Command
  attr_reader :arg
  attr_accessor :op

  def initialize(op, arg)
    @op = op
    @arg = arg.to_i
  end
end

class Parser
  def initialize(input)
    @accumulator = 0
    @index = 0
    @visited = Set.new
    @commands = input.map { |i|
      op, arg = i.scan(/(nop|acc|jmp) ([+-]\d+)/)[0]
      Command.new(op, arg)
    }
  end

  def fixAndRun
    nopsJmps = @commands.filter_map.with_index { |c, i| i if c.op.match(/nop|jmp/) }

    lastModified = -1

    while lastModified < nopsJmps.size do
      begin
        run
        break
      rescue
        switchOp(nopsJmps[lastModified]) if lastModified >= 0
        lastModified += 1
        switchOp(nopsJmps[lastModified])
      end
    end
    @accumulator
  end

  private

  def reset
    @index = 0
    @accumulator = 0
    @visited.clear
  end

  def switchOp(index)
    return if index < 0
    opposite = {
      "nop" => "jmp",
      "jmp" => "nop"
    }
    cmd = @commands[index]
    cmd.op = opposite[cmd.op]
  end

  def run
    reset
    while @index < @commands.size do
      cmd = @commands[@index]

      self.send(cmd.op, cmd.arg)
      @visited.add @index
    end
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
puts Parser.new(Program).fixAndRun
