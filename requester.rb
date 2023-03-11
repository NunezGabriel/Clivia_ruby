module Requester

  def will_save?(score) #FALTA COMPLETAR LA FUNCION XD
    puts "Well done! Your score is #{score}"
    puts "--------------------------------------------------"
    puts "Do you want to save your score? (y/n)"
    print "> "
    score_prompt = gets.chomp

  end

  def gets_option(prompt, options)
    puts options.join(" |")
    print "> "
    prompt = gets.chomp
  end
end
