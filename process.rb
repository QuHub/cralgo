require 'rubygems'
require 'bundler/setup'

Bundler.require

load 'app.rb'

circuit = Circuit::Pla.new('./spec/fixtures/4gt10_22.pla')
algo = Algorithm::Base.new(circuit)
puts algo.inspect
