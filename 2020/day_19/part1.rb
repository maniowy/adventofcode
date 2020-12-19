require 'strscan'

Input = ARGV.empty? ? "input.txt" : ARGV.first
rules, data = File.read(Input).split("\n\n")

rules = rules.split "\n"
data = data.split "\n"

rules = rules.sort { |a,b| a.split(":")[0].to_i <=> b.split(":")[0].to_i }.map { |r| r.split(": ")[1] }

class RegexCompiler
  def initialize rules
    @rules = rules
  end

  def compile
    regexStr = "^#{expand @rules[0]}$"
    Regexp.new regexStr
  end

  def expand rule
    if rule.start_with? "\"" then
      return rule[1]
    end
    if rule.index "|" then
      str = rule.split(" | ").map { |r| expand(r) }.join("|")
      return "(#{str})"
    end
    rule.split(" ").map(&:to_i).reduce("") { |s,r|
      s + expand(@rules[r])
    }
  end
end

compiler = RegexCompiler.new(rules)
regex = compiler.compile

puts data.reduce(0) { |s, d|
  s + (regex.match?(d) ? 1 : 0)
}
