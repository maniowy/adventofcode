require 'set'

Input = File.read("input.txt").split("\n\n")
Required = Set['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']

def YearBetween(min, max)
  lambda { |v|
    v.match(/[1-9]\d{3}/) {|m| (min..max).cover? v.to_i}
  }
end

HeightRanges = {
  'cm' => (150..193),
  'in' => (59..76)
}

Validators = {
  'byr' => YearBetween(1920, 2002),
  'iyr' => YearBetween(2010, 2020),
  'eyr' => YearBetween(2020, 2030),
  'hgt' => lambda {|v|
    v.match(/([1-9]\d*)(in|cm)/) {|m| HeightRanges[m[2]].cover? m[1].to_i}
  },
  'hcl' => lambda {|v| v.match /#([0-9]|[a-f]){6}/},
  'ecl' => lambda {|v| v.match /amb|blu|brn|gry|grn|hzl|oth/},
  'pid' => lambda {|v| v.match /^\d{9}$/},
  'cid' => lambda {|v| true}
}

count = 0

Input.each {|entry|
  fields = entry.split /\n| /
  keyVals = Hash.new
  fields.each{ |f|
    split = f.split(':')
    keyVals[split[0]] = split[1]
  }
  count +=1 if ((Required - Set.new(keyVals.keys)).size == 0) && keyVals.all? {|k,v| Validators[k].call(v)}
}

puts count
