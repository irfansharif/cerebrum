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
end
