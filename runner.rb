#!/usr/bin/env ruby
# encoding: UTF-8
#
# Copyright (C) 2016 Powershop New Zealand Ltd
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
base_dir = File.dirname(File.expand_path($PROGRAM_NAME))
$:.unshift(File.join(base_dir, 'lib'))

require 'dictionary'
require 'interaction'
require 'hangman_factory'
require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: runner.rb [options]"

  opts.on('-l', '--lives LIVES', 'the number of lives (guesses)') { |v| options[:lives] = v }
  opts.on('-h', '--word WORD', 'the word to use, otherwise it will be randomly sourced from a dictionary') { |v| options[:word] = v }
  opts.on('-g', '--[no-]gui', 'run the app in gui mode') { |v| options[:gui] = v }
end.parse!

if options[:word]
  dict = SingleWordDictionary.new(options[:word])
else
  words = File.readlines(File.join(base_dir, 'data', 'words')).map { |line| line.chomp }
  rand = Random.new
  dict = RandomWordDictionary.new(words, rand)
end

lives = (options[:lives] || 6).to_i

factory = HangmanFactory.new(lives)

if options[:gui]
  # tk gui app
  require 'tk'

  input = TkVariable.new
  output = TkVariable.new

  # setup runtime instance
  interaction = TkInteraction.new(input, output)

  require 'tkgame'

  round = TkGame.new(dict, interaction, factory, input, output)
  round.play_round

  Tk.mainloop
else
  # console app
  interaction = ConsoleInteraction.new

  require 'game'

  round = Game.new(dict, interaction, factory)

  # go
  loop do
    round.play_round

    # if we only seeded the game with a single word
    # do not loop
    break if options[:word]

    sleep 5
  end
end
