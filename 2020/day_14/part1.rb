Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n")

class Parser
  def initialize data
    @data = data
    @memory = Hash.new
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
    mask = line.match(/[X10]{36}/)[0]
    @maskOr = mask.match(/1.*/)[0].tr("X","0").to_i 2
    @maskAnd = mask.tr("X","1")
  end

  def updateMemory line
    nc = line.match(/^mem\[(?<addr>\d+)\] = (?<val>\d+)$/).named_captures
    @memory[nc["addr"].to_i] = applyMask nc["val"].to_i
  end

  def applyMask val
    binsize = val.to_s(2).size
    submaskAnd = @maskAnd.slice(@maskAnd.size - binsize, binsize)
    (val & submaskAnd.to_i(2)) | @maskOr
  end

  def getSum
    sum = 0
    @memory.each { |k, v| sum += v }
    sum
  end
end

parser = Parser.new(data)
parser.parse
puts parser.getSum
