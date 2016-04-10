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

  def test_train
    scrubbed_dataset = [
      { input: [ 0.03, 0.7, 0.5 ],            output: [ 1, 0 ] },
      { input: [ 0.16, 0.09, 0.2 ],           output: [ 0, 1 ] },
      { input: [ 0.5, 0.5, 1 ],               output: [ 0, 1 ] }
    ]

    network = Cerebrum.new
    network.train(scrubbed_dataset)
  end
end
