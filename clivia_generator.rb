# do not forget to require your gem dependencies
# do not forget to require_relative your local dependencies
require 'terminal-table'
require 'json'
require 'htmlentities'
require_relative "requester"
require_relative "presenter"

class CliviaGenerator
  # maybe we need to include a couple of modules?
  include Presenter
  include Requester

  def initialize
    # we need to initialize a couple of properties here 
    @options = ["random", "scores", "exit"]
    @prompt = nil
    @score = 0
  end

  def start
    print_welcome
    loop do
      user_input = gets_option(@prompt, @options)
      case user_input
      when "random"
        puts "pusiste random"
      when "scores"
        puts "pusiste scores"
      when "exit"
        break
      else
        puts "Invalid option!"
      end
    end
  end

  def random_trivia # 1 & 2 here
    # load the questions from the api
    # questions are loaded, then let's ask them
  end

  def ask_questions #2
    # ask each question
    # if response is correct, put a correct message and increase score
    # if response is incorrect, put an incorrect message, and which was the correct answer
    # once the questions end, show user's score and promp to save it
  end

  def save(data)
    # write to file the scores data
  end

  def parse_scores
    # get the scores data from file
  end

  def load_questions #1
    # ask the api for a random set of questions
    # then parse the questions
  end

  def parse_questions #here we use htmlentities
    # questions came with an unexpected structure, clean them to make it usable for our purposes
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
