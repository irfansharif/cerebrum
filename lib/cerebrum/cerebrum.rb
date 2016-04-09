require_relative "data_scrub"
require_relative "lookup"
require_relative "lin_alg"
require "pp" #for slightly better logging [temporary]

class Cerebrum
  include Helpers

  attr_accessor :learning_rate, :momentum, :binary_thresh, :hidden_layers

  def initialize(learning_rate: 0.3, momentum: 0.1, binary_thresh: 0.5, hidden_layers: nil)
    @learning_rate  = learning_rate
    @momentum       = momentum
    @binary_thresh  = binary_thresh
    @hidden_layers  = hidden_layers
  end

  def construct_network(sizes)
    @sizes = sizes
    @layers = sizes.length - 1 # Excluding output layer

    @biases = []
    @weights = []
    @outputs = []

    @deltas = []
    @changes = []
    @errors = []

    @layers.times do |layer|
      size = @sizes[layer]
      @deltas[layer] = zeros(size)
      @errors[layer] = zeros(size)
      @outputs[layer] = zeros(size)

      if layer > 0
        @biases[layer] = randos(size)
        @weights[layer] = Array.new(size)
        @changes[layer] = Array.new(size)

        size.times do |node|
          prev_size = @sizes[layer - 1]
          @weights[layer][node] = randos(prev_size)
          @changes[layer][node] = zeros(prev_size)
        end
      end
    end
  end

  def train_pattern(input, target, learning_rate)
    learning_rate = learning_rate || @learning_rate

    # forward propagation
    run_input(input)

    # backward propagation
    calculate_deltas(target)
    adjust_weights(learning_rate)

    # calculate new error
    error = mean_squared_error(@errors[@layers])
  end

  def train(training_set, options = Hash.new)
    training_set = scrub_data_set(training_set)

    iterations      = options[:iterations] || 20000
    error_thresh    = options[:error_threshold] || 0.005
    log             = options[:log] || false
    log_period      = options[:log_period] || 10
    learning_rate   = options[:learning_rate] || 0.3
    error           = Float::INFINITY

    input_size = training_set[0][:input].length
    output_size = training_set[0][:output].length

    hidden_layers = [ [3, (input_size/2).floor].max ] unless @hidden_layers
    sizes = [input_size, hidden_layers, output_size].flatten
    construct_network(sizes)

    iterations.times do |i|
      training_set_err = training_set.map do |example|
        train_pattern(example[:input], example[:output], learning_rate)
      end

      error = training_set_err.inject(:+) / training_set.length

      puts "(#{i}) training error: #{error}" if (log && (i % log_period) == 0)
      break if error < error_thresh
    end

    { error: error, iterations: iteration_num }
  end

  def mean_squared_error(errors)
    sum = 0
    errors.each do |error|
      sum = sum + error * error
    end
    mse = sum / errors.length
  end

  def adjust_weights(rate)
    for layer in 1..@layers
      incoming = @layers[layer - 1]

      for node in 0..@sizes
        delta = @deltas[layer, node]

        for i in 0..incoming.length
          change = @changes[layer, node, i]
          change = rate * delta * incoming[i] +
                    @momentum * change

          @changes[layer][node][i] = change
          @weights[layer][node][i] += change
        end

        @biases[layer, node] += rate * delta
      end
    end
  end

  def calculate_deltas(target)
    @layers.downto(0) do |layer|
       0.upto(@sizes[layer]) do |node|
        output = @outputs[layer][node]
        error = 0
        if layer == @layers
          error = target[node]
        else
          deltas = @deltas[layer + 1]
          deltas.times do |i|
            error += deltas[i] * @weights[layer + 1, i, node]
          end
        end
        @errors[layer][node] = error
        @deltas[layer][node] = error * output * (1 - output)
       end
    end
  end

  def run_input(input)
    @outputs[0] = input
    p "@outputs:"
    pp @outputs
    1.upto(@layers) do |layer|

      0.upto(@sizes[layer] - 1) do |node|
        weights = @weights[layer][node]
        sum = @biases[layer][node]

        0.upto(weights.length - 1) do |i|
          sum += weights[i] * input[i]
        end
        p "layer: #{layer}, node: #{node}"
        @outputs[layer][node] = 1 / (1 + Math.exp(-sum))
      end
      input = @outputs[layer]
      output = @outputs[layer]
    end
    output
  end
end
