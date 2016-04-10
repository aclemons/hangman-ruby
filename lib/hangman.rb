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
require 'set'

class Hangman
  def initialize(word, lives)
    @word, @lives = word, lives
    @normalised_word = word.upcase

    # hash of index,true|false pairs
    @status = 0.upto(@word.length - 1).each_with_object({}) { |i, hash| hash[i] = false }
    @used = Set.new
  end

  def lives
    @lives
  end

  def guess(letter)
    raise ArgumentError, "Input should be a single letter" if letter.length != 1

    raise "Game already over" if @lives == 0

    normalised_letter = letter.upcase

    raise "#{letter} has already been used" if @used.include? normalised_letter

    # record used letters
    @used.add normalised_letter

    # collect indices of new matches
    matches = @normalised_word.chars.to_a.each_with_object({}).with_index do |(c, hash), i|
      hash[i] = true if c == normalised_letter
    end

    if matches.empty?
      @lives -= 1
    else
      @status.merge!(matches)
    end

    # did the guess match
    matches.empty?
  end

  def solved?
    !@status.has_value?(false)
  end

  def used?(letter)
    @used.include?(letter) or @used.include?(letter.upcase)
  end

  def used_letters
    @used.dup
  end

  def game_over?
    @lives == 0
  end

  # arr of char,true|false pairs
  def game_status
    0.upto(@word.length - 1).each_with_object([]) do |i, arr|
      arr.push([ @word[i], @status[i] ])
    end
  end

end
