data = File.read("input.txt").split("\n")

valid = 0
data.each do |line|
  split = line.scan(/([1-9][0-9]*)-([1-9][0-9]*) (.): (.*)/)[0]
  min = split[0].to_i
  max = split[1].to_i
  letter = split[2]
  pwd = split[3]
  count = pwd.count(letter)
  valid +=1 if count >= min && count <= max
end

puts valid
