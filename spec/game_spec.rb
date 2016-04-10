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
require 'game'

RSpec.describe Game do
  let(:hangman) { double("hangman") }
  let(:interaction) { double("interaction") }
  let(:hangman_factory) { double("factory") }
  let(:dictionary) { double("dictionary") }
  let(:game) { Game.new(dictionary, interaction, hangman_factory) }

  describe "#play_round" do
    it "stops after solving" do
      expect(dictionary).to receive(:next_word) { "Test" }

      expect(hangman).to receive(:game_over?).and_return(false, false)
      expect(hangman).to receive(:guess).with("T")
      expect(hangman).to receive(:solved?).and_return(false, true, true)

      expect(hangman_factory).to receive(:new_object).with("Test").and_return(hangman)

      expect(interaction).to receive(:show_status)
      expect(interaction).to receive(:show_status)
      expect(interaction).to receive(:get_letter).and_return("T")
      expect(interaction).to receive(:notify_won)

      game.play_round
    end

    it "stops after lives exhausted" do
      expect(dictionary).to receive(:next_word) { "Test" }

      expect(hangman).to receive(:game_over?).and_return(false, false, true)
      expect(hangman).to receive(:guess).with("x")
      expect(hangman).to receive(:guess).with("e")
      expect(hangman).to receive(:solved?).and_return(false, false, false)

      expect(hangman_factory).to receive(:new_object).with("Test").and_return(hangman)

      expect(interaction).to receive(:show_status)
      expect(interaction).to receive(:show_status)
      expect(interaction).to receive(:show_status)
      expect(interaction).to receive(:get_letter).and_return("x", "e")
      expect(interaction).to receive(:notify_lost)

      game.play_round
    end
  end
end
