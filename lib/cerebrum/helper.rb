module Helpers
  def zeros(size)
    Array.new(size, 0)
  end

  def randos(size)
    Array.new(size) { rand }
  end

  # [{a: 1}, {b: 6, c: 7}] -> {a: 0, b: 1, c: 2}
  def features_to_vector_index_lookup_table(features)
    flattened_feature_keys = features.inject(:merge)
    reindex_hash_values(flattened_feature_keys)
  end

  # changes hash {a: 6, b: 7} to {a: 0, b: 1}
  def reindex_hash_values(hash)
    hash.each_with_index{ |pair, index| hash[pair[0]] = index }
  end

  # formats {a: 0, b: 1}, {a: 6} to [6, 0]
  def to_vector_given_features(features, lookup_table)
    lookup_table.map { |k,v| features[k] || 0 }
  end

  # {a: 0, b: 1}, [6, 7] to {a: 6, b: 7}
  def to_features_given_vector(vector, lookup_table)
    lookup_table.keys.zip(vector).to_h
  end

  # [5, 3] to {5: 0, 3: 1}
  def lookup_table_from_array(arr)
    Hash[arr.each_with_index.map { |val, i| [val, i] }]
  end
end
