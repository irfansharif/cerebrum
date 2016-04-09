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

  def initialize_n_n
    # TODO
  end

  def train_pattern(x, y)
    # TODO
  end

  def train(training_set, options = Hash.new)
    training_set = scrub_data_set(training_set)

    iterations      = options[:iterations] || 20000
    error_thresh    = options[:error_threshold] || 0.005
    log             = options[:log] || false
    log_period      = options[:log_period] || 10
    learning_rate   = options[:learning_rate] || 0.3

    input_size = training_set[0][:input].length
    output_size = training_set[0][:output].length

    hidden_layers = [ [3, (input_size/2).floor].max ] unless @hidden_layers
    sizes = [input_size, hidden_layers, output_size].flatten

    initialize_n_n(sizes)

    error = 1
    iteration_num = 0
    while iteration_num < iterations && error > error_thresh
      sum = 0
      set_iteration = 0
      while set_iteration < training_set.length
        err = train_pattern(
                training_set[set_iteration][:input],
                training_set[set_iteration][:output],
                learning_rate
              )
        sum = sum + err
        set_iteration = set_iteration + 1
      end

      error = sum / training_set.length

      if (log && iteration_num % log_period == 0)
        p "iterations: #{iteration_num}, training error: #{error}"
      end

      iteration_num = iteration_num + 1
    end

   Hash[:error, error, :iterations, iteration_num]
  end
end
