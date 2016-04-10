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
require 'interaction'

RSpec.describe ConsoleInteraction do
  let(:hangman) { double("hangman") }
  subject(:interaction) { ConsoleInteraction.new }

  describe "#show_status" do
    it "correctly renders status" do
      expect(hangman).to receive(:lives).and_return(1, 1)
      expect(hangman).to receive(:game_status) { [ [ "R", true ], [ "u", false ], [ "b", false ], [ "y", false ] ] }
      expect(hangman).to receive(:used_letters) { [ 'R' ] }

      expect { interaction.show_status hangman }.to output("\e[H\e[2J\nYou have 1 life left\nR _ _ _\n\nUsed letters: [ R ]\n").to_stdout
    end
  end

  describe "#notify_won" do
    it "correctly shows win status" do
      expect { interaction.notify_won }.to output("\nYou win!\n").to_stdout
    end
  end

  describe "#notify_lost" do
    it "correctly show lost status including word" do
      expect { interaction.notify_lost "Ruby" }.to output("\nSorry, you did not win. Word was 'Ruby'\n").to_stdout
    end
  end
end

RSpec.describe TkInteraction do
  let(:input) { double("input") }
  let(:output) { double("output") }
  let(:hangman) { double("hangman") }
  subject(:interaction) { TkInteraction.new(input, output) }

  describe "#show_status" do
    it "correctly renders status" do
      expect(hangman).to receive(:lives).and_return(1, 1)
      expect(hangman).to receive(:game_status) { [ [ "R", true ], [ "u", false ], [ "b", false ], [ "y", false ] ] }
      expect(hangman).to receive(:used_letters) { [ 'R' ] }

      expect(output).to receive(:value=).with("You have 1 life left\nR _ _ _\n\nUsed letters: [ R ]")

      interaction.show_status(hangman)
    end
  end

  describe "#notify_won" do
    it "correctly shows win status" do

      expect(output).to receive(:value) { "" }
      expect(output).to receive(:value=).and_return("\nYou win!")

      interaction.notify_won
    end
  end

  describe "#notify_lost" do
    it "correctly show lost status including word" do

      expect(output).to receive(:value) { "" }
      expect(output).to receive(:value=).with("\nSorry, you did not win. Word was 'Ruby'")

      interaction.notify_lost("Ruby")
    end
  end
end
