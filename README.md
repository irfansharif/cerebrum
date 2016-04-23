# GEM: cerebrum ![](https://travis-ci.org/irfansharif/cerebrum.svg?branch=master) [![Gem Version](https://badge.fury.io/rb/cerebrum.svg)](https://badge.fury.io/rb/cerebrum)

`cerebrum` is an implementation of
[ANNs](https://en.wikipedia.org/wiki/Artificial_neural_network)
in Ruby.  There's no reason to train a neural network in Ruby, I'm using it to
experiment and play around with the bare fundamentals of ANNs, original idea
for this project [here](https://github.com/harthur/brain) is currently
unmaintained. Extensions on top of that are personal experimentation.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cerebrum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cerebrum

## Usage

```ruby
require 'cerebrum'

network = Cerebrum.new

network.train([
  {input: [0, 0], output: [0]},
  {input: [0, 1], output: [1]},
  {input: [1, 0], output: [1]},
  {input: [1, 1], output: [0]}
])

result = network.run([1, 0])
# => [0.9333206724219677]

```

### Training

Use `Cerebrum#train` to train the network with an array of training data.

#### Data format

Each training pattern should have an `input:` and an `output:`, both of which
can either be an array of numbers from `0` to `1` or a hash of numbers from `0`
to `1`. An example of the latter is demonstrated below:

```ruby
network = Cerebrum.new

network.train([
    {input: { r: 0.03, g: 0.7, b: 0.5 }, output: { black: 1 }},
    {input: { r: 0.16, g: 0.09, b: 0.2 }, output: { white: 1 }},
    {input: { r: 0.5, g: 0.5, b: 1.0 }, output: { white: 1 }}
]);

result = network.run({ r: 1, g: 0.4, b: 0 })
# => { :black=>0.011967728530458011, :white=>0.9871010273923573 }
```

#### Cerebrum Options

`Cerebrum#new` takes a hash of options that would set defaults if not specified in the `Cerebrum#train` procedure call:

```ruby
network = Cerebrum.new({
  learning_rate:  0.3,
  momentum:       0.1,
  binary_thresh:  0.5,
  hidden_layers:  [3, 4]
})
```

#### Training Options

`Cerebrum#train` optionally takes in a configuration hash as the second argument:

```ruby
network.train(data, {
  error_threshold: 0.005,
  iterations:      20000,
  log:             true,
  log_period:      100,
  learning_rate:   0.3
})
```

The network will train until the training error has gone below the threshold or
the max number of iterations has been reached, whichever comes first.

By default training won't let you know how its doing until the end, but set `log`
to `true` to get periodic updates on the current training error of the network.
The training error should decrease every time. The updates will be printed to
console. If you set `log` to a function, this function will be called with the
updates instead of printing to the console.

The `learning_rate` is a parameter that influences how quickly the network
trains, a number from `0` to `1`. If the learning rate is close to `0` it will
take longer to train. If the learning rate is closer to `1` it will train faster
but it's in danger of training to a local minimum and performing badly on new
data.

#### Output

The output of `Cerebrum#train` is a hash of information about how the training went:

```ruby
network.train(data, options)
# => { error: 0.005324233132423, iterations: 9001 }
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake test` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.  To install this gem onto your local
machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which
will create a git tag for the version, push git commits and tags, and push the
`.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [irfansharif](https://github.com/irfansharif/cerebrum).


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

