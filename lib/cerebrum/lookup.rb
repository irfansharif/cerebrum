module Helpers
  extend self

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
    hash.each_with_index{ |pair, index| hash[pair.first] = index }
  end

  # formats {a: 0, b: 1}, {a: 6} to [6, 0]
  def to_array_given_hash(lookup, hash)
    arr = []
    lookup.map do |k, v|
      arr[v] = hash[k] || 0
    end
    return arr
  end

  # {a: 0, b: 1}, [6, 7] to {a: 6, b: 7}
  def to_hash_given_array(lookup, arr)
    lookup.keys.zip(arr).to_h
  end

  # [5, 3] to {5: 0, 3: 1}
  def lookup_from_array(arr)
    Hash[arr.each_with_index.map { |val, i| [val, i] }]
  end
end
