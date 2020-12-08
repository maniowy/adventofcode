data = File.read("input.txt").split("\n")

valid = 0
data.each do |line|
  split = line.scan(/([1-9][0-9]*)-([1-9][0-9]*) (.): (.*)/)[0]
  first = split[0].to_i
  second = split[1].to_i
  letter = split[2]
  pwd = split[3]
  valid += 1 if (pwd.size >= first && pwd.size >= second) && ((pwd[first-1]==letter) ^ (pwd[second-1]==letter))
end

puts valid
