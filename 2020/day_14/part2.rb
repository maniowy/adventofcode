Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n")

class Parser
  def initialize data
    @data = data
    @memory = Hash.new
    @full = "1"*36
  end

  def parse
    ops = {
      "mask" => "updateMask",
      "mem" => "updateMemory"
    }
    @data.each { |l|
      self.send(ops[l.match(/^(mask|mem)/)[0]], l)
    }
  end

  def updateMask line
    @mask = line.match(/[X10]{36}/)[0]
    @maskOr = @mask.tr("X","0").to_i 2
  end

  def updateMemory line
    nc = line.match(/^mem\[(?<addr>\d+)\] = (?<val>\d+)$/).named_captures
    addr = nc["addr"].to_i | @maskOr
    applyMask(addr).each { |a|
      @memory[a] = nc["val"].to_i
    }
  end

  def applyMask val
    count = @mask.count "X"
    return [] if count == 0

    result = []

    matrix = optionsMatrix count
    matrix.each { |m|
      mask = @mask.clone
      addr = val.dup

      m.each { |x|
        idx = mask.index "X"
        mask[idx] = x.to_s
        bm = 2**(35-idx)
        addr |= bm if x == 1
        addr &= ((@full.to_i 2) ^ bm) if x == 0
      }
      result.push addr
    }
    result
  end

  def getSum
    sum = 0
    @memory.each { |k, v| sum += v }
    sum
  end

  def optionsMatrix n
    n == 1? [[0,1]] : genOptionsMatrix(n)
  end

  def genOptionsMatrix n
    n == 1 ? [0,1] : genOptionsMatrix(n-1).product([0,1]).map {|x| x.flatten}
  end
end

parser = Parser.new(data)
parser.parse
puts parser.getSum
