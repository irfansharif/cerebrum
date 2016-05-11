require_relative "data_scrubber"
require_relative "cerebrum_helper"

class Cerebrum
  include CerebrumHelper
  include DataScrubber

  attr_accessor :learning_rate, :momentum, :binary_thresh, :hidden_layers,
                :input_lookup_table, :output_lookup_table

  def initialize(learning_rate: 0.3, momentum: 0.1, binary_thresh: 0.5, hidden_layers: nil)
    @learning_rate  = learning_rate
    @momentum       = momentum
    @binary_thresh  = binary_thresh
    @hidden_layers  = hidden_layers
  end

  def train_pattern(input, target, learning_rate)
    learning_rate = learning_rate || @learning_rate

    run_input(input)
    calculate_deltas(target)
    adjust_weights(learning_rate)
    mean_squared_error(@errors[@layers])
  end

  def train(training_set, options = Hash.new)
    @input_lookup_table ||= get_input_lookup_table(training_set)
    @output_lookup_table ||= get_output_lookup_table(training_set)
    training_set = scrub_dataset(training_set)

    iterations        = options[:iterations] || 20000
    error_threshold   = options[:error_threshold] || 0.005
    log               = options[:log] || false
    log_period        = options[:log_period] || 10
    learning_rate     = options[:learning_rate] || 0.3
    error             = Float::INFINITY
    current_iteration = 0

    input_size = training_set[0][:input].length
    output_size = training_set[0][:output].length

    @hidden_layers ||= [ [3, (input_size/2).floor].max ]
    layer_sizes = [input_size, @hidden_layers, output_size].flatten
    construct_network(layer_sizes)

    iterations.times do |i|
      current_iteration = i
      training_set_errors = training_set.map { |ex| train_pattern(ex[:input], ex[:output], learning_rate) }
      error = training_set_errors.inject(:+) / training_set.length
      puts "(#{i}) training error: #{error}" if (log && (i % log_period) == 0)

      break if error < error_threshold
    end

    { error: error, iterations: current_iteration }
  end

  def run(input)
    input = to_vector_given_features(input, @input_lookup_table) if @input_lookup_table
    output = run_input(input)
    @output_lookup_table ? to_features_given_vector(output, @output_lookup_table) : output
  end

  private

  def construct_network(layer_sizes)
    @layer_sizes = layer_sizes
    @layers = layer_sizes.length - 1 # Excluding output layer

    @biases, @weights, @outputs = [], [], []
    @deltas, @changes, @errors = [], [], []

    (@layers + 1).times do |layer| # Including output layer
      layer_size = @layer_sizes[layer]
      @deltas[layer] = zeros(layer_size)
      @errors[layer] = zeros(layer_size)
      @outputs[layer] = zeros(layer_size)

      next if layer == 0

      @biases[layer] = randos(layer_size)
      @weights[layer] = Array.new(layer_size)
      @changes[layer] = Array.new(layer_size)
      previous_layer_size = @layer_sizes[layer - 1]

      layer_size.times do |node|
        @weights[layer][node] = randos(previous_layer_size)
        @changes[layer][node] = zeros(previous_layer_size)
      end
    end
  end

  def mean_squared_error(errors)
    sum_of_squares = errors.map{ |error| error ** 2 }.reduce(:+)
    Float(sum_of_squares) / errors.length
  end

  def run_input(input)
    @outputs[0] = input

    (@layers + 1).times do |layer|  # Include output layer
      next if layer == 0

      layer_size = @layer_sizes[layer]
      previous_layer_size = @layer_sizes[layer - 1]

      layer_size.times do |node|
        weights = @weights[layer][node]
        sum = @biases[layer][node]
        previous_layer_size.times do |prev_node|
          sum += @outputs[layer - 1][prev_node] * weights[prev_node]
        end
        @outputs[layer][node] = activation_function(sum)
      end
    end

    @outputs.last
  end

  def calculate_deltas(target)
    @layers.downto(0) do |layer|
      layer_size = @layer_sizes[layer]

      layer_size.times do |node|
        output = @outputs[layer][node]
        error = 0

        if layer == @layers # Output layer
          error = target[node] - output
        else # Hidden layer
          deltas = @deltas[layer + 1]
          deltas.each_with_index do |delta, next_node|
            error += delta * @weights[layer + 1][next_node][node]
          end
        end
        @errors[layer][node] = error
        @deltas[layer][node] = error * output * (1 - output)
      end
    end
  end

  def adjust_weights(rate)
    1.upto(@layers) do |layer|
      prev_layer_output = @outputs[layer - 1]
      layer_size = @layer_sizes[layer]

      layer_size.times do |node|
        delta = @deltas[layer][node]
        prev_layer_output.length.times do |prev_node|
          change = @changes[layer][node][prev_node]
          change = rate * delta * prev_layer_output[prev_node] + (@momentum * change)

          @changes[layer][node][prev_node] = change
          @weights[layer][node][prev_node] += change
        end

        @biases[layer][node] += rate * delta
      end
    end
  end

  def activation_function(sum)
    1 / (1 + Math.exp( -sum ))
  end
end
