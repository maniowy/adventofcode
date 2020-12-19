require 'strscan'

Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n")

class Token
  attr_accessor :item
  attr_reader :oper

  def initialize item, oper
    @item = item
    @oper = oper
  end

  def inspect
    return "{#{item} #{oper}}"
  end

  def <=> other
    if !oper then
      return 1
    end
    if !other.oper then
      return -1
    end
    return 0 if oper == other.oper
    return -1 if oper == "+"
    1 
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

    precedence = [["+"], ["*"]]
    while tokens.size > 1  && !precedence.empty? do
      deleted = false
      tokens.slice(0, tokens.size - 1).each_index { |i|
        lastIndex = i
        lhs = tokens[i].item
        op = tokens[i].oper
        if lhs.is_a? Array then
          lhs = doCalc lhs
        end
        rhs = tokens[i+1].item
        if rhs.is_a? Array then
          rhs = doCalc rhs
        end

        if op && precedence.first.include?(op) then
          tokens[i+1].item = @Operators[op].call lhs, rhs
          tokens.delete_at i
          deleted = true
          break
        end
      }
      precedence.shift unless deleted
    end
    tokens.first.item
  end
end

puts data.reduce(0) { |s, d|
  s + Homework.new(d).calc
}
