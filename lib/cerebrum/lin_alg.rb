class Cerebrum
  def zeros(size)
    Array.new(size, Array.new(size, 0))
  end

  def randos(size)
    Array.new(size, Array.new(size) {rand})
  end
end
