require 'test_helper'

class CerebrumTest < Minitest::Test
  def setup
    @unscrubbed_entirely  = [ { input: { r: 0.03, g: 0.7, b: 0.5 },   output: { black: 1 } },
                              { input: { r: 0.16, g: 0.09, b: 0.2 },  output: { white: 1 } },
                              { input: { r: 0.5, g: 0.5, b: 1 },      output: { white: 1 } } ]
    @scrubbed_input       = [ { input: [ 0.03, 0.7, 0.5 ],            output: { black: 1 } },
                              { input: [ 0.16, 0.09, 0.2 ],           output: { white: 1 } },
                              { input: [ 0.5, 0.5, 1 ],               output: { white: 1 } } ]
    @scrubbed_output      = [ { input: { r: 0.03, g: 0.7, b: 0.5 },   output: [ 1, 0 ] },
                              { input: { r: 0.16, g: 0.09, b: 0.2 },  output: [ 0, 1 ] },
                              { input: { r: 0.5, g: 0.5, b: 1 },      output: [ 0, 1 ] } ]
    @fully_scrubbed       = [ { input: [ 0.03, 0.7, 0.5 ],            output: [ 1, 0 ] },
                              { input: [ 0.16, 0.09, 0.2 ],           output: [ 0, 1 ] },
                              { input: [ 0.5, 0.5, 1 ],               output: [ 0, 1 ] } ]
    @network = Cerebrum.new
  end

  def test_input_vector_unaffected_through_scrub
    assert_equal @network.scrub_dataset(@scrubbed_input), @fully_scrubbed
  end

  def test_output_vector_unaffected_through_scrub
    assert_equal @network.scrub_dataset(@scrubbed_output), @fully_scrubbed
  end

  def test_dataset_unaffected_through_scrub
    assert_equal @network.scrub_dataset(@fully_scrubbed), @fully_scrubbed
  end

  def test_dataset_scrubbed_correctly
    assert_equal @network.scrub_dataset(@unscrubbed_entirely), @fully_scrubbed
  end
end
