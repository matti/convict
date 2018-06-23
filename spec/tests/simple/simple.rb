puts "hello"

class A
  def value
    puts "hello in value"
    111
  end
end

module B
  def self.world
    puts "world"
  end
end

a = A.new
B.world

return a.value
