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

nearbyTickets = data[2].lines.slice(1, data[2].lines.size - 1).map { |t| t.split(",").map { |x| x.to_i } }

nearbyTickets.delete_if { |ticket|
  ticket.any? { |x|
    rules.none? { |n, r|
      r1, r2 = r
      (r1.include? x) || (r2.include? x)
    }
  }
}

#puts "Valid nearby tickets: #{nearbyTickets}"

possibleRules = []
myTicket.each { |x|
  possibleRules.push rules.filter { |n, r|
    r1, r2 = r
    r1.include?(x) || r2.include?(x)
  }.keys
}

#puts "Possible rules for my ticket: #{possibleRules}"

nearbyTickets.each { |ticket|
  ticket.each.with_index { |x, i|
    possibleRules[i].delete_if { |p|
      r1,r2 = rules[p]
      !r1.include?(x) && !r2.include?(x)
    }
  }
}
while possibleRules.any? {|pr| pr.is_a?(Array)} do
  possibleRules.map! { |t| (t.is_a?(Array) && t.size == 1) ? t[0] : t }
  possibleRules.each_index { |idx|
    next if !possibleRules[idx].is_a?(Array)
    possibleRules[idx].delete_if { |r|
      possibleRules.any? { |x| !x.is_a?(Array) && x == r }
    }
  }
end
possibleRules.map! { |t| (t.is_a?(Array) && t.size == 1) ? t[0] : t }
puts possibleRules.each_with_index.reduce(1){ |sum, (name, index)|
  if name.match /^departure/ then
    sum *= myTicket[index]
  end
  sum
} 
