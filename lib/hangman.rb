require 'json'

class Hangman

  def initialize(word)
    @word = word.downcase.split("")
    @guesses_left = 8
    @correct_letters = []
    @incorrect_letters = []
    @exit = false
  end

  def to_json
    JSON.dump ({
    :word => word,
    :guesses_left => @guesses_left,
    :correct_letters => @correct_letters,
    :incorrect_letters => @incorrect_letters
    })
  end

  def save_file
    File.write('Project-Hangman-TOP-Project/lib/save_data.json', to_json)
  end

  def load_file
    data = File.read('Project-Hangman-TOP-Project/lib/save_data.json')
    load_content = JSON.load data
    @word = load_content["word"].downcase.split("")
    @guesses_left = load_content["guesses_left"]
    @correct_letters = load_content["correct_letters"]
    @incorrect_letters = load_content["incorrect_letters"]
  end

  def play_game
    while @guesses_left > 0
      print "\nGuesses left: #{@guesses_left}\nIncorrect Letters: "
      @incorrect_letters.each { |n| print n + ' '}
      print "\nSave Game: Type save\nExit Game: Type exit"
      print "\nWord: "
      @word.each { |letter|
        if @correct_letters.include? letter
          print letter + ' '
        else
          print '_ '
        end
      }
      print "\nEnter a guess: "
      guess = gets.chomp.downcase
      if repeat_guess?(guess)
        puts "\nThe letter #{guess} has already been used, please try again.\n\n"
        next
      elsif guess.length == word.length && correct_answer?(guess)
        puts "\nCorrect! You Win! The word is indeed #{word}"
        break
      elsif guess == 'save'
        puts "\nGame saved!\n"
        self.save_file
      elsif guess == 'exit'
        @exit = true
        break
      else
        puts "\n#{guess} is incorrect, please try again.\n\n"
      end

      if @word.include?(guess)
        puts "\nCorrect! The word has the letter #{guess}!\n\n"
        @correct_letters << guess
      else
        if guess.length == 1
          puts "\nIncorrect! The word does not have the letter #{guess}\n\n"
          @incorrect_letters << guess
        end
        @guesses_left -= 1 unless guess == 'save'
      end
      
      if won?
        puts "You win! The word is #{word}!"
        break
      end

      if lose?
        puts "You lose! The correct word is #{word}"
      end
    end

  end

  def exit?
    @exit
  end

  def repeat_guess?(letter)
    @correct_letters.include?(letter) || 
    @incorrect_letters.include?(letter)  
  end
  
  def correct_answer?(answer)
    answer.downcase == word.downcase
  end

  def valid_letter?(letter)
    letter.match?(/[[:alpha:]]/) && letter.length == 1
  end


  def won?
    result = true
    @word.uniq.each { |letter|
      result = false unless @correct_letters.include? letter
    }
    result
  end


  def lose?
    @guesses_left == 0
  end


  def word
    @word.join("").capitalize
  end

end


