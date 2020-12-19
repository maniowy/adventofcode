Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n\n")

rules = Hash.new

data[0].lines.each { |r|
  match = r.match(/(?<name>.*): (?<l1>\d+)-(?<h1>\d+) or (?<l2>\d+)-(?<h2>\d+)/)
  captures = match.named_captures
  name = captures["name"]
  l1 = captures["l1"].to_i
  h1 = captures["h1"].to_i
  l2 = captures["l2"].to_i
  h2 = captures["h2"].to_i
  rules[name] = [(l1..h1), (l2..h2)]
}

myTicket = data[1].lines[1].split(",").map { |x| x.to_i }

nearbyTickets = data[2].split("\n").slice(1, data[2].lines.size - 1).map { |t| t.split(",").map { |x| x.to_i } }

puts nearbyTickets.reduce(0) { |sum, ticket|
  ticket.each { |x|
    sum += x if rules.none? { |n, r|
      r1, r2 = r
      (r1.include? x) || (r2.include? x)
    }
  }
  sum
}
