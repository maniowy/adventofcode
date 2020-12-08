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

direct,indirect = bags.partition { |b, s| s.has_key? Wanted }

def findMatching(sub, bags, wanted)
  return 1 if sub.any? { |n, c| bags[n].has_key? wanted }
  ssub = sub.reduce(Hash.new) { |sum,sub|
    n, c = sub
    sum.merge(bags[n])
  }
  return findMatching(ssub, bags, wanted) if !ssub.empty? 
  0
end

count = indirect.reduce(direct.size) { |sum, bag|
  b, s = bag
  sum + findMatching(s, bags, Wanted)
}

puts count
