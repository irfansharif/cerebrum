require 'test_helper'

class CerebrumTest < Minitest::Test
  def setup
    @network = Cerebrum.new
  end

  def test_that_it_has_a_version_number
    refute_nil ::Cerebrum::VERSION
  end

  def test_default_options_are_set_and_accessible
    assert_equal @network.learning_rate, 0.3
    assert_equal @network.momentum, 0.1
    assert_equal @network.binary_thresh, 0.5
  end

  def test_run
    @dataset  = [
      { input: { a: 0, b: 0 }, output: { o: 0 } },
      { input: { a: 0, b: 1 }, output: { o: 1 } },
      { input: { a: 1, b: 0 }, output: { o: 1 } },
      { input: { a: 1, b: 1 }, output: { o: 0 } }
    ]

    @network = Cerebrum.new
    @network.train(@dataset)
    result = @network.run({a: 1,b: 0})

    assert (0.9..1.0).include? result[:o]
  end
end
