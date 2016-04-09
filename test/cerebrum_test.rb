require 'test_helper'

class CerebrumTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Cerebrum::VERSION
  end

  def test_default_options_are_set_and_accessible
    network = Cerebrum.new

    assert_equal network.learning_rate, 0.3
    assert_equal network.momentum, 0.1
    assert_equal network.binary_thresh, 0.5
  end

  def test_build_lookup
    network = Cerebrum.new

    hashes = [{a: 1}, {b: 6, c: 7}]
    result = {a: 0, b: 1, c: 2}
    assert_equal network.build_lookup(hashes), result
  end

  def test_lookup_from_hash
    network = Cerebrum.new

    hash = {a: 6, b: 7}
    result = {a: 0, b: 1}
    assert_equal network.lookup_from_hash(hash), result
  end


  def test_to_array_given_hash
    network = Cerebrum.new

    lookup = {a: 0, b: 1}
    arr = {a: 6}
    result = [6, 0]
    assert_equal network.to_array_given_hash(lookup, arr), result
  end

  def test_to_hash_given_array
    network = Cerebrum.new

    lookup = {a: 0, b: 1}
    arr = [6, 7]
    result = {a: 6, b: 7}
    assert_equal network.to_hash_given_array(lookup, arr), result
  end

  # [5, 3] to {5: 0, 3: 1}
  def test_lookup_from_array
    network = Cerebrum.new

    arr = [5, 3]
    result = {5 => 0, 3 => 1}
    assert_equal network.lookup_from_array(arr), result
  end
end
