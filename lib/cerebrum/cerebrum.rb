require_relative "data_scrub"
require_relative "lookup"

class Cerebrum
  attr_accessor :learning_rate, :momentum, :binary_thresh, :hidden_layers

  def initialize(learning_rate: 0.3, momentum: 0.1, binary_thresh: 0.5, hidden_layers: nil)
    @learning_rate  = learning_rate
    @momentum       = momentum
    @binary_thresh  = binary_thresh
    @hidden_layers  = hidden_layers
  end

  def train(training_set, options = Hash.new)
    training_set = scrub_data_set(training_set)
  end
end
