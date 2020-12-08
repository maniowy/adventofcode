file = File.open("input.txt", "r")
input = []
file.each { |line| input.push line.to_i }

def product2(numbers, targetSum)
  numbers.each { |i|
    j = targetSum - i
    return i*j if numbers.include? j
  }
  nil
end

def product3(numbers, targetSum)
  numbers.each { |i|
    j = product2(numbers, targetSum - i)
    return i*j if j
  }
  nil
end

puts product3(input, 2020)
