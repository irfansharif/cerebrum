class Cerebrum
  def scrub_dataset(dataset)
    dataset = scrub_input(dataset) unless dataset[0][:input].is_a? Array
    dataset = scrub_output(dataset) unless dataset[0][:output].is_a? Array
    dataset
  end

  private

  def scrub_input(dataset)
    input_features = dataset.map { |ex| ex[:input] }
    input_lookup_table = features_to_vector_index_lookup_table(input_features)
    dataset.each do |ex|
      ex[:input] = to_vector_given_features(ex[:input], input_lookup_table)
    end
  end

  def scrub_output(dataset)
    output_features = dataset.map { |ex| ex[:output] }
    output_lookup_table = features_to_vector_index_lookup_table(output_features)
    dataset.each do |ex|
      ex[:output] = to_vector_given_features(ex[:output], output_lookup_table)
    end
  end
end
