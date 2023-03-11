# do not forget to require your gem dependencies
# do not forget to require_relative your local dependencies
require "terminal-table"
require "json"
require "htmlentities"
require "httparty"
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
  end

  def start
    print_welcome
    loop do
      user_input = gets_option(@prompt, @options)
      case user_input
      when "random"
        random_trivia
      when "scores"
        print_scores
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
        puts "#{@index + 1}. #{option}"
      end
      print "> "
      answer = gets.chomp.to_i
      if question_options[answer - 1] == element[:correct_answer]
        puts "#{question_options[answer - 1]}... CORRECT you're smart :)"
        @score += 10
      else
        puts "#{question_options[answer - 1]}... INCORRECT!"
        puts "The correct answer was: #{element[:correct_answer]}"
      end
    end
    save_options
    @score = 0
    # para que ya no de error aca debes reiniciar la clase
  end

  def sorting_answers(element)
    arr = element[:incorrect_answers]
    arr.push(element[:correct_answer])
    arr.shuffle
    arr.uniq
  end

  def load_questions
    parse_body = JSON.parse(@response.body, symbolize_names: true)
  end

  def save_options
    user_save_score = will_save?(@score)
    if ["y", "Y"].include?(user_save_score)
      puts "Type the name to assign to the score"
      print "> "
      @name = gets.chomp
      @name = "Anonymous" if @name == ""
      save(@name, @score)
      print_welcome
    elsif ["n", "N"].include?(user_save_score)
      print_welcome
    else
      puts "invalid option!"
    end
  end

  def save(name, score)
    data = File.read("score.json")
    score_parsed = JSON.parse(data)
    element = { "name" => name, "score" => score }
    score_parsed["players"] << element
    File.write("score.json", JSON.pretty_generate(score_parsed))
  end

  def print_scores # here we use terminal-table
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
    top_table
    data = File.read("score.json")
    score_parsed = JSON.parse(data)
    score_body = []
    score_parsed["players"].each do |user|
      arr = [user["name"], user["score"]]
      score_body << arr
    end
    table = Terminal::Table.new rows: score_body
    puts "#{table}"
  end
end

# ras = CliviaGenerator.new
# ras.save()
