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
    # load the questions from the api
    # questions are loaded, then let's ask them
    decoder = HTMLEntities.new
    # real_index = nil
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
    will_save?(@score)
  end

  def ask_questions 
    # ask each question
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
  end

  def sorting_answers(element)
    arr = element[:incorrect_answers]
    arr.push(element[:correct_answer])
    arr.shuffle
  end

  def load_questions #0.5
    parse_body = JSON.parse(@response.body, symbolize_names: true)
  end

  def save(data)
    # write to file the scores data
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

# ras = CliviaGenerator.new

# ras.random_trivia