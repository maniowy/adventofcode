Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n")

class CubeMesh
  def initialize data
    @mesh = [data.map { |l| l.split("").map { |c| c == '.' ? 0 : 1 } }]
  end

  def dump mesh = nil
    mesh = @mesh if !mesh
    mesh.each_index { |x|
      printZ mesh, x
    }
  end

  def printZ mesh, index
    puts "z=#{index-1}:"
    mesh[index].each { |l|
      puts "#{l}"
    }
    puts
  end

  def iterate n
    #puts "Before any cycles:"
    #dump @mesh
    #puts
    1.upto(n).each { |i|
      @mesh = expand(@mesh)
      snapshot = Marshal.load(Marshal.dump(@mesh))
      snapshot.each.with_index { |z, zi|
        z.each.with_index { |y, yi|
          y.each.with_index { |x, xi|
            count = countSiblings snapshot, zi, yi, xi
            s = switch(x, count)
            @mesh[zi][yi][xi] = s
          }
        }
      }
      @mesh = crop @mesh
      #puts "After #{n} cycle(s):"
      #dump @mesh
      #puts
    } 
  end

  def switch x, count
    return 0 if x == 1 && !([2,3].include? count)
    return 1 if x == 0 && count == 3
    x
  end

  def countSiblings snapshot, z, y, x
    count = 0
    (z-1..z+1).each { |zi|
      next if !((0..snapshot.size-1).include? zi)
      (y-1..y+1).each { |yi|
        next if !((0..snapshot[zi].size-1).include? yi)
        (x-1..x+1).each { |xi|
          next if xi == x && yi == y && zi == z
          next if !((0..snapshot[zi][yi].size-1).include? xi)
          count += snapshot[zi][yi][xi]
        }
      }
    }
    count
  end

  def expand mesh
    if mesh.any? { |z| z[0].include? 1 } then
      mesh.each { |z| z.insert(0, Array.new(z[0].size, 0)) }
    end
    if mesh.any? { |z| z.last.include? 1 } then
      mesh.each { |z| z.insert(z.size, Array.new(z[0].size, 0)) }
    end
    if mesh.any? { |z| z.any? { |y| y[0] == 1 } } then
      mesh.each { |z| z.each { |y| y.insert(0, 0) } }
    end
    if mesh.any? { |z| z.any? { |y| y[y.size-1] == 1 } } then
      mesh.each { |z| z.each { |y| y.insert(y.size, 0) } }
    end
    if mesh.first.any? { |y| y.include? 1 } then
      rowsize = mesh.first[0].size
      mesh.insert(0, Array.new)
      1.upto(rowsize).each { |i|
        mesh.first.push Array.new(rowsize, 0)
      }
    end
    if mesh.last.any? { |y| y.include? 1 } then
      rowsize = mesh.last[0].size
      mesh.insert(mesh.size, Array.new)
      1.upto(rowsize).each { |i|
        mesh.last.push Array.new(rowsize, 0)
      }
    end
    mesh
  end

  def crop mesh
    if mesh.all? { |z| !z[0].include? 1 } then
      mesh.map! { |z| z.slice(1, z.size - 1) }
    end
    if mesh.all? { |z| !z.last.include? 1 } then
      mesh.map! { |z| z.slice(0, z.size - 1) }
    end
    if mesh.all? { |z| z.all? { |y| y[0] == 0 } } then
      mesh.map! { |z| z.map { |y| y.slice(1, y.size - 1) } }
    end
    if mesh.all? { |z| z.all? { |y| y[y.size - 1] == 0 } } then
      mesh.map! { |z| z.map { |y| y.slice(0, y.size - 1) } }
    end
    if mesh.first.all? { |y| !y.include?(1) } then
      mesh.delete_at 0
    end
    if mesh.last.all? { |y| !y.include?(1) } then
      mesh.delete_at(mesh.size - 1)
    end
    mesh
  end

  def countActive
    @mesh.reduce(0) { |sum, dim|
      sum + dim.reduce(0) { |s, l|
        s + l.reduce(:+)
      }
    }
  end
end

mesh = CubeMesh.new(data)
mesh.iterate 6
puts mesh.countActive
