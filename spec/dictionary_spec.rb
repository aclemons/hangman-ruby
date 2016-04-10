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
require 'dictionary'

RSpec.describe SingleWordDictionary do
  let(:dictionary) { SingleWordDictionary.new ("Ruby") }

  describe "#next_word" do
    it "returns the same word for every call" do
      20.times { expect(dictionary.next_word).to eq "Ruby" }
    end
  end
end

RSpec.describe RandomWordDictionary do
  let(:dictionary) { RandomWordDictionary.new(%w(word1 word2 word3), random) }
  let(:random) { double("random") }

  describe "#next_word" do
    it "returns a random word for each call" do
      expect(random).to receive(:rand).with(0..2).and_return(1, 2)

      expect(dictionary.next_word).to eq "word2"
      expect(dictionary.next_word).to eq "word3"
    end
  end
end
