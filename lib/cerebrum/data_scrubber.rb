module DataScrubber
  private

  def scrub_dataset(dataset)
    dataset = scrub_input(dataset) unless dataset[0][:input].is_a? Array
    dataset = scrub_output(dataset) unless dataset[0][:output].is_a? Array
    dataset
  end

  def get_input_lookup_table(dataset)
    input_features = dataset.map { |ex| ex[:input] }
    (input_features.first.is_a? Array) ? nil : features_to_vector_index_lookup_table(input_features)
  end

  def get_output_lookup_table(dataset)
    output_features = dataset.map { |ex| ex[:output] }
    (output_features.first.is_a? Array) ? nil : features_to_vector_index_lookup_table(output_features)
  end

  def scrub_input(dataset)
    input_lookup_table = get_input_lookup_table(dataset)
    dataset.each do |ex|
      ex[:input] = to_vector_given_features(ex[:input], input_lookup_table)
    end
  end

  def scrub_output(dataset)
    output_lookup_table = get_output_lookup_table(dataset)
    dataset.each do |ex|
      ex[:output] = to_vector_given_features(ex[:output], output_lookup_table)
    end
  end
end
