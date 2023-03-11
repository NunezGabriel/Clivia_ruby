# do not forget to require your gem dependencies
# do not forget to require_relative your local dependencies
require 'terminal-table'
require 'json'
require 'htmlentities'
require 'httparty'
require_relative "requester"
require_relative "presenter"

class CliviaGenerator

  include Presenter
  include Requester

  def initialize
    @base_uri = "https://opentdb.com/api.php?amount=10"
    @response = HTTParty.get(@base_uri)
    @questions = load_questions[:results]
    @options = ["random", "scores", "exit"]
    @prompt = nil
    @score = 0
    @index = nil
    @name = nil
    @player = []
  end

  def start
    print_welcome
    loop do
      user_input = gets_option(@prompt, @options)
      case user_input
      when "random"
        random_trivia 
      when "scores"
        puts "pusiste scores"
      when "exit"
        end_img
        break
      else
        puts "Invalid option!"
      end
    end
  end

  def random_trivia 
    decoder = HTMLEntities.new
    @questions.each do |element|
      puts "Category: #{element[:category]} | Difficulty: #{element[:difficulty]}"
      puts "Question: #{decoder.decode(element[:question])}"
      question_options = sorting_answers(element)
      question_options.each do |option|
        @index = question_options.index(option)
        puts "#{@index+1}. #{option}"
      end
      print "> "
      answer = gets.chomp.to_i
      if question_options[answer-1] == element[:correct_answer]
        puts "#{question_options[answer-1]}... CORRECT you're smart :)"
        @score+=10
      else
        puts "#{question_options[answer-1]}... INCORRECT!"
        puts "The correct answer was: #{element[:correct_answer]}"
      end
    end
    save_options
  end


  def sorting_answers(element)
    arr = element[:incorrect_answers]
    arr.push(element[:correct_answer])
    arr.shuffle
  end

  def load_questions #0.5
    parse_body = JSON.parse(@response.body, symbolize_names: true)
  end

  def save_options
    user_save_score = will_save?(@score)
    if user_save_score == "y" || user_save_score == "Y"
      puts "Type the name to assign to the score"
      print "> "
      @name = gets.chomp
      if @name == ""
        @name = "Anonymous"
      end
      save(@name, @score)
      print_welcome
    elsif user_save_score == "n" || user_save_score == "N"
      print_welcome
    else
      puts "invalid option!"
    end
  end


  def save(name,score)
    @player << { name: name, score: score }
    File.open('score.json', 'w') do |f|
      f.write(JSON.generate(@player))
    end
  end

  def parse_scores
    # get the scores data from file
  end

  def print_scores #here we use terminal-table
    # print the scores sorted from top to bottom
    # +-----------+-------+
    # |    Top Scores     |
    # +-----------+-------+
    # | Name      | Score |
    # +-----------+-------+
    # | Deyvi     | 40    | }
    # | Diego     | 40    | }
    # | Wences    | 30    | } el sorteo del orden en la funcion print_scores
    # | Anonymous | 20    | }
    # +-----------+-------+
  end
end