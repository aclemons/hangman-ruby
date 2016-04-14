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

    # array where each index holds solved state of chars in @word
    @status = 0.upto(@word.length - 1).map { false }
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
    matches = @normalised_word.chars.to_a.map { |c| c == normalised_letter }

    if matches.include?(true)
      matches.each_with_index { |m, i| @status[i] ||= m }
    else
      @lives -= 1
    end

    # did the guess match
    matches.empty?
  end

  def solved?
    !@status.include?(false)
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
    0.upto(@word.length - 1).map { |i| [ @word[i], @status[i] ] }
  end

end
