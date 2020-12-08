require 'set'

Input = File.read("input.txt").split("\n\n")

Required = Set['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']

count = 0

Input.each {|entry|
  fields = entry.split /\n| /
  keys = Set[]
  fields.each{ |field|
    keys.add? field.split(':')[0]
  }
  count += 1 if (Required - keys).size == 0
}

puts count
