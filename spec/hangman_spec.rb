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
require 'hangman'

RSpec.describe Hangman do
  let(:word) { "Ruby" }
  let(:lives) { 2 }
  subject(:hangman) { Hangman.new(word, lives) }

  context "when no guesses have been made" do
    let(:word) { "Ry" }
    it do
      expect(hangman.game_status).to eq [ [ "R", false ], [ "y", false ] ]
      expect(hangman.solved?).to be_falsey
      expect(hangman.game_over?).to be_falsey
      expect(hangman.used_letters.empty?).to be_truthy
      expect(hangman.lives).to eq 2
    end
  end

  context "when incorrect guesses were made, but game is not over" do
    let(:word) { "Ry" }
    it do
      hangman.guess "q"
      expect(hangman.game_status).to eq [ [ "R", false ], [ "y", false ] ]
      expect(hangman.solved?).to be_falsey
      expect(hangman.game_over?).to be_falsey
      expect(hangman.used?("q")).to be_truthy
      expect(hangman.lives).to eq 1
    end
  end

  context "when incorrect guess was made, ending the game" do
    let(:lives) { 1 }
    it do
      hangman.guess "q"
      expect(hangman.game_status).to eq [ [ "R", false ], [ "u", false ], [ "b", false ], [ "y", false ] ]
      expect(hangman.solved?).to be_falsey
      expect(hangman.game_over?).to be_truthy
      expect(hangman.used?("q")).to be_truthy
      expect(hangman.lives).to eq 0
    end
  end

  context "when a correct guess was made, but case differs" do
    it do
      hangman.guess "r"
      expect(hangman.game_status).to eq [ [ "R", true ], [ "u", false ], [ "b", false ], [ "y", false ] ]
      expect(hangman.solved?).to be_falsey
      expect(hangman.game_over?).to be_falsey
      expect(hangman.used?("R")).to be_truthy
      expect(hangman.used?("r")).to be_truthy
      expect(hangman.lives).to eq 2
    end
  end

  context "when a correct guess was made, ending the game" do
    let(:word) { "Ry" }
    it do
      hangman.guess "r"
      expect(hangman.game_status).to eq [ [ "R", true ], [ "y", false ] ]
      expect(hangman.solved?).to be_falsey
      expect(hangman.game_over?).to be_falsey
      expect(hangman.used?("R")).to be_truthy
      expect(hangman.used?("r")).to be_truthy
      expect(hangman.lives).to eq 2

      hangman.guess "y"
      expect(hangman.game_status).to eq [ [ "R", true ], [ "y", true ] ]
      expect(hangman.solved?).to be_truthy
      expect(hangman.game_over?).to be_falsey
      expect(hangman.used?("R")).to be_truthy
      expect(hangman.used?("r")).to be_truthy
      expect(hangman.lives).to eq 2
    end
  end
end

