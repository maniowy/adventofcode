require 'strscan'

Input = ARGV.empty? ? "input.txt" : ARGV.first
rules, data = File.read(Input).split("\n\n")

rules = rules.split "\n"
data = data.split "\n"

rules = rules.sort { |a,b| a.split(":")[0].to_i <=> b.split(":")[0].to_i }.map { |r| r.split(": ")[1] }
rules[8] = "42 | 42 8"
rules[11] = "42 31 | 42 11 31"

class RegexCompiler
  def initialize rules
    @rules = rules
    @nested = Hash.new
  end

  def compile
    regexStr = "^#{expand @rules[0], 0}$"
    Regexp.new regexStr
  end

  def expand rule, index 
    if rule.start_with? "\"" then
      return rule[1]
    end
    if rule.index "|" then
      str = rule.split(" | ").map { |r| expand(r, index) }.join("|")
      return "(#{str})"
    end
    rule.split(" ").map(&:to_i).reduce("") { |s,r|
      if r.to_i == index then
        if @nested.has_key? index then
          @nested[index] += 1
        else
          @nested[index] = 1
        end
      end
      if @nested.has_key? r.to_i then
        return s if @nested[r.to_i] >= 5
      end
      s + expand(@rules[r], r)
    }
  end
end

compiler = RegexCompiler.new(rules)
regex = compiler.compile

puts data.reduce(0) { |s, d|
  s + (regex.match?(d) ? 1 : 0)
}
