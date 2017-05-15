class GamesController < ApplicationController
  require 'open-uri'
  require 'json'
  require 'date'


  def play
    @game = "Hehe"
    @grid = (0..9 - 1).map { ("a".."z").to_a[rand(26)] }
    @start_time = Time.now
    # raise
  end

  def seeresult
    @end_time = Time.now
    # raise
    @results = run_game(params[:attempt], params[:grid], Time.parse(params[:start_time]), @end_time)
    # @results = attempt_included_in_the_grid?(params[:attempt], params[:grid])
    #TRUE
    # @results = translation_exists?(params[:attempt])
    #TRUE
    # @result = get_translation(params[:attempt])
    #TRUE

  end

  private

  def run_game(attempt, grid, start_time, end_time)
    # DONE: runs the game and return detailed hash of result
    if translation_exists?(attempt) && attempt_included_in_the_grid?(attempt, grid)
      # attempt.size == grid.size ? score = (attempt.size + 100) : score = attempt.size + 100
      score = attempt.size * 100 - (end_time - start_time).to_f
      message = "well done"
    # elsif translation_exists?(attempt) && attempt_included_in_the_grid?(attempt, grid)
    #   score = 0
    #   message = "not in the grid"
  elsif attempt_included_in_the_grid?(attempt, grid) == false
    score = 0
    message = "not in the grid"
  else #translation_exists?(attempt) = false
    score = 0
    message = "not an english word"
  end

  { attempt: attempt,
    time: (end_time - start_time).to_f,
    translation: get_translation(attempt),
    score: score,
    message: message }
  end

  # attempt = params[:attempt]
  # grid = params[:grid]
  def attempt_included_in_the_grid?(attempt, grid)
    attempt.chars.all? { |letter| attempt.upcase.count(letter.upcase) <= grid.upcase.chars.count(letter.upcase) }
  end

  def translation_exists?(attempt)
    systran_api_key = '481c072f-0af2-4052-99de-391e410533e1'
    base_url = 'https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key='
    url = base_url + systran_api_key + '&input=' + attempt
    json_response = open(url)
    translation = JSON.parse(json_response.read.to_s)
    translation["outputs"][0]["output"] == attempt ? false : true
  end

  def get_translation(attempt)
    systran_api_key = '481c072f-0af2-4052-99de-391e410533e1'
    base_url = 'https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key='
    url = base_url + systran_api_key + '&input=' + attempt
    json_response = open(url)
    translation = JSON.parse(json_response.read.to_s)
    translation["outputs"][0]["output"] == attempt ? nil : translation["outputs"][0]["output"]
  end

end
