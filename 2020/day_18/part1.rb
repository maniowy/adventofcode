require 'strscan'

Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n")

class Token
  attr_reader :item, :oper

  def initialize item, oper
    @item = item
    @oper = oper
  end

  def inspect
    return "{#{item} #{oper}}"
  end
end

class Tokenizer
  attr_reader :tokens

  def initialize data
    @data = StringScanner.new data.tr(" ", "")
    @tokenBegin = /\d+|\(/
    @operator = /\+|\*/
    @tokens = []
  end

  def tokenize
    @tokens = doTokenize @data
  end

  def doTokenize data
    tokens = []
    while data.check_until @tokenBegin do
      data.scan_until @tokenBegin
      item = data.matched
      if item == "(" then
        sub = getSubExpression(data)
        token = doTokenize(StringScanner.new(sub))
        data.pos += sub.size
        data.scan_until @operator
        oper = data.matched
        tokens.push Token.new(token, oper)
      else
        number = item.to_i
        data.scan_until @operator
        oper = data.matched
        tokens.push Token.new(number, oper)
      end
    end
    tokens
  end

  def getSubExpression data
    pos = data.pos
    openParenthesesCount = 0
    while openParenthesesCount >= 0
      char = data.scan_until /\(|\)/
      openParenthesesCount += 1 if data.matched == "("
      openParenthesesCount -= 1 if data.matched == ")"
      raise unless data.matched?
    end
    endPos = data.pos
    data.pos = pos
    data.peek(endPos - pos - 1)
  end
end

class Homework

  def initialize data
    @tokens = Tokenizer.new(data).tokenize

    @Operators = {
      "*" => lambda { |x, y| x*y },
      "+" => lambda { |x, y| x+y }
    }
  end

  def calc 
    doCalc @tokens
  end

  def doCalc tokens
    lastOper = nil
    result = nil
    tokens.each { |t|
      #require 'pry'; binding.pry
      item = t.item
      op = t.oper
      if item.is_a? Array then
        item = doCalc item
      end
      result = item if !result
      if lastOper then
        result = @Operators[lastOper].call result, item
      end
      lastOper = op
    }
    result
  end
end

puts data.reduce(0) { |s, d|
  s + Homework.new(d).calc
}
