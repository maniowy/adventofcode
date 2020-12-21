Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n")

class Food
  attr_accessor :ingredients, :allergens
  def initialize ingredients, allergens
    @ingredients = ingredients
    @allergens = allergens
  end
end

foodList = data.map { |line|
  match = line.match /(.+) \(contains (.+)\)/
  Food.new(match[1].split(" "), match[2].split(", "))
}

foodMap = Hash.new
foodList.each { |f|
  f.ingredients.each { |i|
    if !foodMap.has_key? i then
      foodMap[i] = f.allergens.dup
    else
      foodMap[i] += f.allergens
      foodMap[i].uniq!
    end
  }
}
foodList.each { |food|
  food.ingredients.each { |ingredient|
    food.allergens.each { |allergen|
      foodList.each { |f|
        next if f == food
        if f.allergens.include?(allergen) && !f.ingredients.include?(ingredient) then
          foodMap[ingredient].delete(allergen)
          break
        end
      }
    }
  }
}
allergenLess = foodMap.filter { |i,a| a.empty? }.map { |i, a| i }
puts allergenLess.reduce(0) { |s,i|
  s + foodList.reduce(0) { |s2, f|
    s2 + (f.ingredients.include?(i) ? 1 : 0)
  }
}
