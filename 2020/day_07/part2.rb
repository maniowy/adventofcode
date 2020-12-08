data = File.read("input.txt").split("\n")

bags = Hash.new

Empty = /^(?<name>.+) bags contain no other bags\.$/
NonEmpty = /^(?<name>.+) bags contain (?<sub>\d+ .+ bag[s]?)+\.$/
SubMatch = /^(?<count>\d+) (?<name>.+) bag[s]?$/

empty, nonempty = data.partition { |l| Empty.match l }

empty.each { |e|
  bags[Empty.match(e).named_captures["name"]] = {}
}

nonempty.each { |ne|
  NonEmpty.match(ne) { |m|
    sub = m.named_captures["sub"].split(", ")
    subbags = Hash.new
    sub.each { |s|
      SubMatch.match(s) { |sm|
        subbags[sm.named_captures["name"]] = sm.named_captures["count"].to_i
      }
    }
    bags[m.named_captures["name"]] = subbags 
  }
}

Wanted = "shiny gold"

def countBags(bags, name)
  bags[name].reduce(0) { |s, b|
    n, c = b
    s + c + c*countBags(bags, n)
  }
end

count = countBags(bags, Wanted)

puts count
