module Requester

  def ask_question(question)
    # show category and difficulty from question
    # show the question
    # show each one of the options
    # grab user input
  end

  def will_save?(score) #FALTA COMPLETAR LA FUNCION XD
    # show user's score
    puts "Well done! Your score is #{score}"
    puts "--------------------------------------------------"
    # ask the user to save the score
    puts "Do you want to save your score? (y/n)"
    # grab user input
    print "> "
    score_prompt = gets.chomp
    # prompt the user to give the score a name if there is no name given, set it as Anonymous
    if score_prompt == "y" || "Y"
      puts "Type the name to assign to the score"
      print "> "
    else
      print_welcome 

  end

  def gets_option(prompt, options)
    puts options.join(" |")
    print "> "
    prompt = gets.chomp
  end
end
