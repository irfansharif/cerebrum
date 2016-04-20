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

  def test_train
    @dataset  = [
      { input: { r: 0.03, g: 0.7, b: 0.5 },   output: { black: 1 } },
      { input: { r: 0.16, g: 0.09, b: 0.2 },  output: { white: 1 } },
      { input: { r: 0.5, g: 0.5, b: 1 },      output: { white: 1 } }
    ]

    @network = Cerebrum.new
    @network.train(@dataset)
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

    actual_result = @network.run({a: 1,b: 0})[:o].round(1)
    result = 0.9

    assert_equal actual_result, result
  end
end
