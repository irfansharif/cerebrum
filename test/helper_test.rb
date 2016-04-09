require 'test_helper'

class HelperTest < Minitest::Test
  def test_build_lookup
    hashes = [{a: 1}, {b: 6, c: 7}]
    result = {a: 0, b: 1, c: 2}
    assert_equal Helpers.build_lookup(hashes), result
  end

  def test_lookup_from_hash
    hash = {a: 6, b: 7}
    result = {a: 0, b: 1}
    assert_equal Helpers.lookup_from_hash(hash), result
  end

  def test_to_array_given_hash
    lookup = {a: 0, b: 1}
    arr = {a: 6}
    result = [6, 0]
    assert_equal Helpers.to_array_given_hash(lookup, arr), result
  end

  def test_to_hash_given_array
    lookup = {a: 0, b: 1}
    arr = [6, 7]
    result = {a: 6, b: 7}
    assert_equal Helpers.to_hash_given_array(lookup, arr), result
  end

  # [5, 3] to {5: 0, 3: 1}
  def test_lookup_from_array
    arr = [5, 3]
    result = {5 => 0, 3 => 1}
    assert_equal Helpers.lookup_from_array(arr), result
  end
end
