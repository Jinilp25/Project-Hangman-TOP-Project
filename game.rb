require_relative "lib/hangman.rb"


def main_menu
  while true
    print "\nHangman TOP Project!\n1: Play Game\n2: Load\n3: Exit\nPlease Choose an option: "
    player_option = gets.chomp.to_i
    if player_option == 1
      return "new"
    elsif player_option == 2
      return "load"
    elsif player_option == 3
      puts "Goodbye!"
      return
    else
      puts "Please select a valid option (1 2 3)"
    end
  end
end

def play(file, type)
  rand_num = rand(file.length)
  rand_word = file[rand_num]
  play_hangman = Hangman.new(rand_word)
  if type == 'load'
    play_hangman.load_file
  end
  play_hangman.play_game
  unless play_hangman.exit?
    print "\nTry another game? (Y/N): " 
    new_round = gets.chomp.downcase
  end
  if new_round == "y" || new_round == "yes"
    puts "Starting a new round...\n\n"
    play(file, 'new')
  else
    puts "Thanks for playing! Goodbye!"
  end
end

def main()
  words_file = open("Project-Hangman-TOP-Project/lib/google-10000-english-no-swears.txt")
  words_data = words_file.readlines
  words_file.close
  words_data.map! { |word| word.chomp}
  words_data.select! { |n| n.length >= 5 && n.length <= 12}

  main_choice = main_menu
  if main_choice == "new"
    play(words_data, 'new')
  elsif main_choice == "load"
    play(words_data, 'load')
  end
end

main