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
require 'tk'

class TkGame
  def initialize(dictionary, interaction, factory, input, output)

    @dictionary, @interaction, @hangman_factory, @input, @output = dictionary, interaction, factory, input, output

    ph = { 'padx' => 20, 'pady' => 20 }

    guess_proc = proc { guess_hangman }
    restart_proc = proc { play_round }

    root = TkRoot.new { title "Hangman" }
    root.bind("Return") { guess_hangman }

    top = TkFrame.new(root)

    init_label top, ph
    init_input top, ph
    init_buttons top, guess_proc, restart_proc, ph

    # now pack all the elements in the gui
    top.pack('fill' => 'both', 'side' => 'top')

  end

  def play_round
    @word = @dictionary.next_word
    @hangman = @hangman_factory.new_object @word

    @interaction.show_status(@hangman)
    @guess_button.state('active')
    @entry.focus
  end

private

  def init_label(top, ph)
    label = TkLabel.new(top, 'textvariable' => @output)
    label.pack(ph)
  end

  def init_input(top, ph)
    @entry = TkEntry.new(top, 'textvariable' => @input)
    @entry.pack(ph)
  end

  def init_buttons(top, guess_proc, restart_proc, ph)
    @guess_button = TkButton.new(top) { text 'Guess'; command guess_proc; pack ph }
    @restart_button = TkButton.new(top) { text 'Restart'; command restart_proc; pack ph }
  end

  def guess_hangman
    letter = @interaction.get_letter @hangman

    if letter
      @hangman.guess letter
      @input.value = ""

      @interaction.show_status(@hangman)

      if @hangman.solved?
        @interaction.notify_won
        @guess_button.state('disabled')
      elsif @hangman.game_over?
        @interaction.notify_lost @word
        @guess_button.state('disabled')
      end
    end
  end

end
