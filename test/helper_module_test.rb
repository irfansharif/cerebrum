require 'test_helper'

class HelperTest < Minitest::Test
  def setup
    @network = Cerebrum.new
  end

  def test_features_to_lookup_table_conversion
    features = [{a: 1}, {b: 6, c: 7}]
    lookup_table = {a: 0, b: 1, c: 2}
    assert_equal @network.features_to_vector_index_lookup_table(features), lookup_table
  end

  def test_reindexing_hash_values
    hash = {a: 6, b: 7}
    reindexed_hash = {a: 0, b: 1}
    assert_equal @network.reindex_hash_values(hash), reindexed_hash
  end

  def test_features_to_vector_conversion
    lookup_table = {a: 0, b: 1}
    features = {a: 6}
    vector = [6, 0]
    assert_equal @network.to_vector_given_features(features, lookup_table), vector
  end

  def test_vector_to_feature_conversion
    lookup_table = {a: 0, b: 1}
    vector = [6, 7]
    feature = {a: 6, b: 7}
    assert_equal @network.to_features_given_vector(vector, lookup_table), feature
  end

  # [5, 3] to {5: 0, 3: 1}
  def test_lookup_table_from_array
    arr = [:a, :b]
    lookup_table = {a: 0, b: 1}
    assert_equal @network.lookup_table_from_array(arr), lookup_table
  end
end
