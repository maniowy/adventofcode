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
foodMap.filter! { |i, a| !a.empty? }
while foodMap.any? { |i, a| a.size > 1 } do
  foodMap.filter { |i, a| a.size == 1 }.each { |ingredient, allergens|
    foodMap.each { |i, a|
      next if i == ingredient
      a.delete allergens.first
    }
  }
end
foodMap.transform_values! { |v| v.first }
puts foodMap.to_a.sort { |(k1, v1),(k2, v2)| v1 <=> v2 }.map { |(k,v)| k }.join ","
