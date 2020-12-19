Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n")

arrival = data[0].to_i
schedule = data[1].gsub(",x", "").split(",").map(&:to_i)

wait = nil
id = nil

schedule.each { |s|
  diff = 0
  while (arrival + diff) % s != 0 do
    diff += 1
  end
  if !wait || diff < wait then
    wait = diff
    id = s
  end
}

puts wait*id
