Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n\n")

class Tile
  attr_accessor :id, :image

  @@Operations = [:identity, :flipHorizontal, :flipVertical, :rotate90, :rotate180, :rotate270, :rotate90flipH, :rotate90flipV, :rotate270flipH, :rotate270flipV]

  def initialize id, image
    @id = id
    @image = image
  end

  def self.operations
    @@Operations
  end

  def empty?
    !id || !image
  end

  def identity tile
    self
  end

  def flipHorizontal tile
    Tile.new(@id, tile.image.reverse)
  end

  def flipVertical tile
    Tile.new(@id, tile.image.map { |r| r.reverse })
  end

  def rotate90 tile
    cols = []
    @image.first.reverse.split('').each_index { |i|
      cols.push @image.map { |r| r[i] }.join.reverse
    }
    Tile.new(@id, cols)
  end

  def rotate180 tile
    Tile.new(@id, flipHorizontal(flipVertical(tile)).image)
  end

  def rotate270 tile
    cols = []
    @image.first.split('').each_index { |i|
      cols.push @image.map { |r| r[i] }.join
    }
    Tile.new(@id, cols.reverse)
  end

  def rotate90flipH tile
    flipHorizontal(rotate90(tile))
  end

  def rotate90flipV tile
    flipVertical(rotate90(tile))
  end

  def rotate270flipH tile
    flipHorizontal(rotate270(tile))
  end

  def rotate270flipV tile
    flipVertical(rotate270(tile))
  end

  def getBorder side
    return "" unless @image
    case side
    when :top
      @image.first
    when :bottom
      @image.last
    when :left
      @image.map { |r| r[0] }.join
    when :right
      @image.map { |r| r[r.length-1] }.join
    end 
  end

  def getBorders sides
    sides.map { |s|
      getBorder s
    }
  end

  def getAllBorders
    getBorders [:bottom, :top, :left, :right]
  end
end

class Image
  attr_reader :tiles

  def initialize
    @tiles = [[Tile.new(nil,nil)]]
  end

  def addTile tile, x, y
    if y == -1 || y == @tiles.size then
      row = []
      @tiles.first.each_index { |i|
        row.push tile if i == x
        row.push Tile.new(nil, nil) if i != x
      }
      @tiles.insert(0, row) if y < 0
      @tiles.push row if y == @tiles.size
    elsif x == -1 then
      @tiles.each_index { |i|
        @tiles[i].insert(0, tile) if i == y
        @tiles[i].insert(0, Tile.new(nil, nil)) if i != y
      }
    elsif x == @tiles.first.size then
      @tiles.each_index.each { |i|
        @tiles[i].push tile if i == y
        @tiles[i].push Tile.new(nil, nil) if i != y
      }
    else
      @tiles[y][x] = tile
    end
  end

  def dump
    @tiles.each { |r|
      first = r.first
      (0..9).each { |i|
        r.each { |t|
          print "#{t.image[i]} " unless t.empty?
          print ("e"*10)+" " if t.empty?
        }
        print "\n"
      }
      puts
    }
  end

  def dumpIds
    @tiles.each { |r|
      r.each { |t|
        print t.id unless t.empty?
        print "empty" if t.empty?
        print " "
      }
      puts
    }
  end

  def getNeighbors x, y
    neighbors = Hash.new
    neighbors[:left] = @tiles[y][x-1] if x - 1 >= 0
    neighbors[:right] = @tiles[y][x+1] if x + 1 < @tiles[y].size
    neighbors[:top] = @tiles[y-1][x] if y - 1 >= 0
    neighbors[:bottom] = @tiles[y+1][x] if y + 1 < @tiles.size
    neighbors.filter { |k, v| !v.empty? }
  end
end

class Matcher
  attr_reader :image

  def initialize tiles
    @tiles = tiles.map { |t|
      lines = t.split "\n"
      id = lines.shift.match(/Tile (\d+):/)[1].to_i
      Tile.new id, lines
    }
    @image = Image.new
    @Opposite = {
      :left => :right,
      :right => :left,
      :top => :bottom,
      :bottom => :top
    }
  end

  def compileImage
    inner = @tiles.filter { |t|
      t.getAllBorders().all? { |b|
        @tiles.filter { |t2| t2 != t }.any? { |tile|
          Tile.operations.any? { |o|
            transformed = tile.send(o, tile)
            transformed.getAllBorders.include? b
          }
        }
      }
    }
    outer = @tiles.filter { |t| !inner.include? t }

    @image.addTile outer.shift, 0, 0
    compile outer + inner

    @image
  end

  def compile unmatched
    left = unmatched.size
    progressed = true
    while !unmatched.empty? && progressed do
      last = nil
      unmatched.each { |t|
        last = nil
        matched = match t
        next unless matched
        last = t
        transformed,x,y = matched
        @image.addTile transformed, x, y
        break
      }
      unmatched.delete last
      progressed = (unmatched.size != left)
      left = unmatched.size
    end
  end

  def match tile
    tiles = @image.tiles

    Tile.operations.each { |o|
      transformed = tile.send(o, tile)
      bottom, top, left, right = transformed.getAllBorders
      tiles.first.each.with_index { |t, i|
        return [transformed, i, -1] if t.getBorder(:top) == bottom
        return [transformed, i + 1, 0] if t.getBorder(:right) == left
        return [transformed, i - 1, 0] if t.getBorder(:left) == right
      }
      tiles.last.each.with_index { |b, i|
        return [transformed, i, tiles.size] if b.getBorder(:bottom) == top
        return [transformed, i + 1, tiles.size - 1] if b.getBorder(:right) == left
        return [transformed, i - 1, tiles.size - 1] if b.getBorder(:left) == right
      }
      tiles.each.with_index { |y, i|
        return [transformed, -1, i] if y.first.getBorder(:left) == right
        return [transformed, y.size, i] if y.last.getBorder(:right) == left
        return [transformed, 0, i - 1] if i - 1 >= 0 && y.first.getBorder(:top) == bottom
        return [transformed, 0, i + 1] if i + 1 < tiles.size && y.first.getBorder(:bottom) == top
        return [transformed, y.size - 1, i - 1] if i - 1 >= 0 && y.last.getBorder(:top) == bottom
        return [transformed, y.size - 1, i + 1] if i + 1 < tiles.size && y.last.getBorder(:bottom) == top
      }
      tiles.each.with_index { |y, j|
        y.each.with_index { |x, i|
          next unless x.empty?
          neighbors = @image.getNeighbors(i,j)
          return [transformed, i, j] if !neighbors.empty? && neighbors.all? { |k, v|
            transformed.getBorder(k) == v.getBorder(@Opposite[k])
          }
        }
      }
    }
    nil
  end
end

matcher = Matcher.new data
matcher.compileImage
tiles = matcher.image.tiles
puts tiles.first.first.id * tiles.first.last.id * tiles.last.first.id * tiles.last.last.id
#matcher.image.dump
#matcher.image.dumpIds
