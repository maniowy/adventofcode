Input = ARGV.empty? ? "input.txt" : ARGV.first
data = File.read(Input).split("\n\n")

class Player
  attr_accessor :cards
  attr_reader :name

  def initialize name, cards
    @name = name
    @cards = cards
  end
end

class Game
  attr_reader :players

  def initialize data
    @players = data.map { |x|
      lines = x.split("\n")
      Player.new(lines.shift, lines.map {|x| x.to_i})
    }
  end

  def play
    while @players.all? { |p| !p.cards.empty? } do
      round
    end
    self
  end

  def round
    return if @players.any? { |p| p.cards.empty? }
    cards = [@players[0].cards.shift, @players[1].cards.shift]
    if cards[0] > cards[1] then
      @players[0].cards += cards
    else
      @players[1].cards += cards.reverse
    end
  end
end

game = Game.new(data).play
winner = game.players.filter { |p| !p.cards.empty? }.first
puts winner.cards.reverse.each.with_index.reduce(0) { |s, (card, index)|
  s + (index + 1) * card
}
