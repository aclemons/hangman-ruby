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
class Interaction
  def show_status(hangman)
    status_text = "You have #{hangman.lives} #{hangman.lives == 1 ? "life" : "lives"} left\n"

    blanks = hangman.game_status.each_with_object([]) do |(letter, status), arr|
      arr << "#{status ? letter : "_"}"
    end

    status_text += blanks.join(" ")
    status_text += "\n"

    status_text += "\nUsed letters: [ "
    status_text +=  hangman.used_letters.sort.join(" ")
    status_text += " ]"
  end

  def notify_lost(word)
    "\nSorry, you did not win. Word was '#{word}'"
  end

  def notify_won
    "\nYou win!"
  end

protected
  def validate_letter(letter, hangman)
    if letter.length != 1
      return [ false,  "Invalid input. Try again." ]
    end

    if hangman.used?(letter)
      return [ false, "Letter already used. Try again." ]
    end

    if not letter =~ /[[:alpha:]]/
      return [ false, "Input not a letter. Try again." ]
    end

    return [ true, nil ]
  end
end

class ConsoleInteraction < Interaction
  def show_status(hangman)
    puts "\e[H\e[2J" # clear screen
    puts super(hangman)
  end

  def get_letter(hangman)
    puts ""
    print "Please enter a letter: "

    letter = gets.chomp.rstrip.lstrip
    puts ""

    valid, error = validate_letter letter, hangman

    if not valid
      show_status hangman
      puts error
      return false
    end

    return letter
  end

  def notify_lost(word)
    puts super(word)
  end

  def notify_won
    puts super
  end
end

class TkInteraction < Interaction
  def initialize(input, output)
    @input, @output = input, output
  end

  def show_status(hangman)
    @output.value = super(hangman)
  end

  def notify_lost(word)
    @output.value += super(word)
  end

  def notify_won
    @output.value += "\nYou win!"
  end

  def get_letter(hangman)

    letter = @input.value
    valid, error = validate_letter letter, hangman

    if not valid
      show_status hangman
      @output.value += error
      @input.value = ""
      return false
    end

    return @input.value
  end
end

