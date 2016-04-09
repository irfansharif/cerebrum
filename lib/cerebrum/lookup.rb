class Cerebrum
  private
  # Purpose: sparse hash <---> array

  # Purpose: sparse hash <---> array

  # [{a: 1}, {b: 6, c: 7}] -> {a: 0, b: 1, c: 2}
  def build_lookup(hashes)
    hash = {}
    hashes.map do |k|
      k.each do |v|
        hash[v[0]] = v[1]
      end
    end
    lookup_from_hash(hash)
  end

  # changes hash {a: 6, b: 7} to {a: 0, b: 1}
  def lookup_from_hash(hash)
    lookup = {}
    hash.each_with_index.map { |x, i| lookup[x[0]] = i }
    return lookup
  end

  # formats {a: 0, b: 1}, {a: 6} to [6, 0]
  def to_array(lookup, hash)
    arr = []
    lookup.map do |k, v|
      arr[v] = hash[k] || 0
    end
    return arr
  end

  # {a: 0, b: 1}, [6, 7] to {a: 6, b: 7}
  def to_hash(lookup, arr)
    hash = {}
    lookup.map do |k, v|
      hash[k] = arr[v]
    end
    return hash
  end

  # [5, 3] to {5: 0, 3: 1}
  def lookup_from_array(arr)
    lookup = {}
    arr.each_with_index do |k, i|
      lookup[k] = i
    end
    return lookup
  end
end
