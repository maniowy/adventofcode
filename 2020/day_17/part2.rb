Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n")

class CubeMesh
  def initialize data
    @active = []
    data.each.with_index { |l,i|
      l.split("").each.with_index { |c,j|
        @active.push [0,0,i,j] if c == '#'
      }
    }
  end

  def dump mesh = nil
    puts "#{@active}"
  end

  def countActive
    @active.count
  end

  def iterate n
    #puts "Before any cycles:"
    #dump @active
    #puts
    1.upto(n).each { |i|
      active = []
      @active.each { |a|
        activeSiblings = getActiveSiblings a
        active.push(a) if activeSiblings.size.between?(2, 3)
        siblings = getInactiveSiblings(a)
        siblings.each { |s|
          next if active.include? s
          active.push s if testActiveSiblings(s, 3)
        }
      }
      @active = active
      #puts "After #{i} cycle:"
      #dump @active
      #puts "#{active.count}\n"
    } 
  end

  def getActiveSiblings item
    @active.filter { |o|
      o != item &&
        (-1..1).include?(o[0]-item[0]) &&
        (-1..1).include?(o[1]-item[1]) && 
        (-1..1).include?(o[2]-item[2]) &&
        (-1..1).include?(o[3]-item[3])
    }
  end

  def testActiveSiblings item, limit
    count = 0
    @active.each { |o|
      if o != item &&
        (-1..1).include?(o[0]-item[0]) &&
        (-1..1).include?(o[1]-item[1]) && 
        (-1..1).include?(o[2]-item[2]) &&
        (-1..1).include?(o[3]-item[3]) then
        count += 1
      end
      break if count > limit
    }
    return count == limit
  end

  def getInactiveSiblings item
    w,z,y,x = item
    siblings = []
    (w-1..w+1).each { |wi|
      (z-1..z+1).each { |zi|
        (y-1..y+1).each { |yi|
          (x-1..x+1).each { |xi|
            next if xi == x && yi == y && zi == z && wi == w
            coord = [wi,zi,yi,xi]
            next if @active.include? coord
            siblings.push coord
          }
        }
      }
    }
    siblings
  end
end

mesh = CubeMesh.new(data)
mesh.iterate 6
puts mesh.countActive
