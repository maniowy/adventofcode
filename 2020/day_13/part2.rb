Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n")

schedule = data[1].split(",").map.with_index{|s,i| [s,i]}.filter {|x| x[0] != 'x'}.map{|x| [x[0].to_i,x[1]] }

def findCommon x, ts, diff
  mod, rem = x
  while true do
    break if (ts + rem)%mod == 0
    ts += diff
  end
  ts
end

diff = schedule.shift[0]
timestamp = diff
schedule.each { |x|
  mod, rem = x
  timestamp = findCommon(x, timestamp, diff)
  diff = mod.lcm(diff)
}

puts "#{timestamp}"
